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
    func updateMusicLabel(text: String)
    func updateArtistLabel(text: String)
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
            delegate?.updateMusicLabel("END")
            delegate?.updateArtistLabel("")
            delegate?.updatePlayBtnsTitle("▷")
            return  // itemが一つもなかったので戻る
        }
        mediaItems.removeAll()
        mediaItems = items
        currentIndex = 0
        actPickItem()
        
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch{
            fatalError("カテゴリ設定失敗")
        }
        
        do{
            try audioSession.setActive(true)
        }
        catch{
            fatalError("session有効化失敗")
        }

        
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
                delegate?.updateMusicLabel(item.title ?? "")
                delegate?.updateArtistLabel(item.artist ?? "")
            }
            catch  {
                // エラー発生してプレイヤー作成失敗
                audioPlayer = nil
                delegate?.updateMusicLabel(item.title ?? "This title")
                delegate?.updateArtistLabel("Cannot Play")
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "actError", userInfo: nil, repeats: false)
                return false
            }
        }
        else {
            audioPlayer = nil
            delegate?.updateMusicLabel(item.title ?? "This title")
            delegate?.updateArtistLabel("Cannot Play(No URL)")
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "actError", userInfo: nil, repeats: false)
            return false
        }
        return true
    }
    
    func actError(){
        nextItem()
    }
    
    func play() {
        if let player = audioPlayer {
            player.play()
            nowPlaying = true
            // メッセージラベルに再生中アイテム情報を表示
            let item = mediaItems[currentIndex]
            delegate?.updateMusicLabel(item.title ?? "")
            delegate?.updateArtistLabel(item.artist ?? "")
            
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
            delegate?.updateMusicLabel("END")
            delegate?.updateArtistLabel("")
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
            delegate?.updateMusicLabel(item.title ?? "")
            delegate?.updateArtistLabel(item.artist ?? "")
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
            delegate?.updateMusicLabel("END")
            delegate?.updateArtistLabel("")
            delegate?.updatePlayBtnsTitle("▷")
            return
        }
        else {
            nextItem()// 次の曲へ。
        }
    }
}

