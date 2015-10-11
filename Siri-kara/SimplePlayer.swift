//
//  SimplePlayer.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

protocol SimplePlayerDelegate {
    func updateMessage(text: String)
    func updatePlayBtnsTitle(text: String)
    
}

class SimplePlayer: NSObject, AVAudioPlayerDelegate {
    
    var delegate: SimplePlayerDelegate?
    private var audioPlayer: AVAudioPlayer?
    private var mediaItems = [MPMediaItem]()
    private var currentIndex: Int = 0
    private (set) var nowPlaying: Bool = false
    
    func pickItems(items: [MPMediaItem]) {
        // 選択した曲情報がmediaItemCollectionに入っている
        // mediaItemCollection.itemsから入っているMPMediaItemの配列を取得できる
        //let items = mediaItemCollection.items
        if items.count == 0 {
            delegate?.updateMessage("END")
            delegate?.updatePlayBtnsTitle("▷")
            return  // itemが一つもなかったので戻る
        }
        mediaItems = items
        currentIndex = 0
        actPickItem()
    }
    
    private func actPickItem(){
        if updatePlayer(){
            play()
        }
    }
    
    /// プレイヤーにitemをセットして更新
    func updatePlayer()->Bool {
        let item = mediaItems[currentIndex]// MPMediaItemのassetURLからプレイヤーを作成する
        
        if let url: NSURL = item.assetURL {
            do {
                // itemのassetURLからプレイヤーを作成する
                audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                
                // (アイテム末尾に到達したときに呼ばれるaudioPlayerDidFinishPlaying()を受ける)
                audioPlayer?.delegate = self
                
                // メッセージラベルに再生中アイテム情報を表示
                let song = item.title ?? ""
                let artist = item.artist ?? ""
                let text = song + " | " + artist
                delegate?.updateMessage(text)
            }
            catch  {
                // エラー発生してプレイヤー作成失敗
                audioPlayer = nil
                
                // messageLabelに失敗したことを表示
                let title = item.title ?? "こ"
                let text = title + "のurlは再生できません"
                delegate?.updateMessage(text)
                return false
            }
        }
        else {
            audioPlayer = nil
            // messageLabelにurlがnilのため失敗したことを表示
            let title = item.title ?? "こ"
            let text = title + "のurlはnilのため再生できません"
            delegate?.updateMessage(text)
            return false
        }
        return true
    }
    
    func play() {
        if let player = audioPlayer {
            player.play()
            nowPlaying = true
            // メッセージラベルに再生中アイテム情報を表示
            let item = mediaItems[currentIndex]
            let song = item.title ?? ""
            let artist = item.artist ?? ""
            let text = song + " | " + artist
            delegate?.updateMessage(text)
            
            // 再生中なので、再生&一時停止ボタンの表示を「一時停止」にする
            delegate?.updatePlayBtnsTitle("||")
        }
        else{
            actUpdatePlayBtnsTitle()
        }
    }
    
    func pause() {
        if let player = audioPlayer {
            player.pause()
            nowPlaying = false
            // 再生をとめたので、再生&一時停止ボタンの表示を「再生」にする
            delegate?.updatePlayBtnsTitle("▷")
        }
        else{
            actUpdatePlayBtnsTitle()
        }
    }
    
    func nextItem() {
        if currentIndex >= mediaItems.count - 1 {
            currentIndex = mediaItems.count
            delegate?.updateMessage("END")
            return
        }
        currentIndex++
        actPlayItem()
    }

    func prevItem() {
        if currentIndex <= 0 {
            return
        }
        else if currentIndex == mediaItems.count{
            let item = mediaItems[mediaItems.count - 1 ]
            let song = item.title ?? ""
            let artist = item.artist ?? ""
            let text = song + " | " + artist
            delegate?.updateMessage(text)
            currentIndex--
            return
        }
        currentIndex--
        actPlayItem()
    }
    
    private func actPlayItem(){
        //updatePlayer()
        if nowPlaying{
            if updatePlayer(){
                play()
            }
            else{
                delegate?.updatePlayBtnsTitle("▷")
            }
        }
        else{
            if updatePlayer(){
                pause()
            }
            else{
                delegate?.updatePlayBtnsTitle("||")
            }
        }
    }
    
    private func actUpdatePlayBtnsTitle(){
        if nowPlaying{
            delegate?.updatePlayBtnsTitle("||")
        }
        else{
            delegate?.updatePlayBtnsTitle("▷")
        }
    }
    
    /// アイテム末尾に到達したときに呼ばれる
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        // 最後の曲の場合は終了。そうでないなら次の曲へ
        if currentIndex >= mediaItems.count - 1{
            currentIndex = 0
            updatePlayer()
            pause()
            delegate?.updateMessage("END")
            delegate?.updatePlayBtnsTitle("▷")
            return
        }
        else {
            nextItem()// 次の曲へ。
        }
    }
}

