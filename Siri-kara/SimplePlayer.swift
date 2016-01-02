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
    func updateArtworkImage(Artwork: MPMediaItemArtwork) //tsuiki1
    func updateDummyArtworkImage() //tsuiki1
}

class SimplePlayer: NSObject, AVAudioPlayerDelegate {
    
    var delegate: SimplePlayerDelegate?
    private var audioPlayer: AVAudioPlayer?
    private var mediaItems = [MPMediaItem]()
    private var currentIndex: Int = 0
    private (set) var nowPlaying: Bool = false
    private let numOfHowToRead:u_int = 10
    var talker = AVSpeechSynthesizer()
    
    func pickItems(items: [MPMediaItem]) {
        // 選択した曲情報がmediaItemCollectionに入っている
        // mediaItemCollection.itemsから入っているMPMediaItemの配列を取得できる
        if items.count == 0 {
            delegate?.updateMusicLabel("END")
            delegate?.updateArtistLabel("")
            delegate?.updatePlayBtnsTitle("▷")
            delegate?.updateDummyArtworkImage()
            
            return  // itemが一つもなかったので戻る
        }
        mediaItems.removeAll()
        mediaItems = items
        currentIndex = 0
        
        //リモートコントロールイベントを受け取るための設定を追加
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        //バックグラウンド再生するための設定
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
        
        if updatePlayer(currentIndex){
            play()
        }
    }
    

    // プレイヤーにitemをセットして更新
    func updatePlayer(track_number :Int)->Bool {
        let item = mediaItems[track_number]// MPMediaItemのassetURLからプレイヤーを作成する
        
        if let url: NSURL = item.assetURL {
            do {
                // itemのassetURLからプレイヤーを作成する
                audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                
                // (アイテム末尾に到達したときに呼ばれるaudioPlayerDidFinishPlaying()を受ける)
                audioPlayer?.delegate = self
                
                // メッセージラベルに再生中アイテム情報を表示
                delegate?.updateMusicLabel(item.title ?? "")
                delegate?.updateArtistLabel(item.artist ?? "")
                
                //ジャケット表示
                if(item.artwork != nil){
                    delegate?.updateArtworkImage(item.artwork!) //tsuiki1
                }
                else {
                    delegate?.updateDummyArtworkImage() //tsuiki1
                }
                
                // タイトルの読み上げ
                if talker.speaking {
                    talker.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
                }
                let rand_str = Int(arc4random_uniform(numOfHowToRead)) // 読み上げ文字列のランダム選択
                var readStr = ""
                switch rand_str {
                    case 0:
                        readStr = "次の曲は、" + item.title! + "となります。よぉ　チェケラ！"
                    case 1:
                        readStr = "次はペンネーム、しりとりいのちさんのリクエスト、" + item.title! + "です。どうぞ。"
                    case 2:
                        readStr = "月が綺麗ですね。" + item.title!
                    case 3:
                        readStr = "毎日お仕事お疲れ様。そんなあなたに届けたいこの曲、" + item.title!
                    case 4:
                        readStr = "続いての曲はあのときにいっせいを風靡したこの曲。" + item.title!
                    case 5:
                        readStr = "続いての曲は" + item.title! + "です。よいしょぉぉ"
                    case 6:
                        readStr = "お待たせしました。まんを持しての登場です。" + item.title!
                    case 7:
                        readStr = "まちぢゅうでの評判ナンバーワン！「この曲を聞くと泣けてきます。」というこの曲、" + item.title!
                    case 8:
                        readStr = "ふふふ、、、ついにこの曲が来てしまいましたか、、、" + item.title!
                    case 9:
                        readStr = "うーん、なんてクールでグルーヴィーな曲なんだ！" + item.title!
                    default:
                        readStr = "NO MUSIC"
                }
                let utterance = AVSpeechUtterance(string: readStr)
                talker.speakUtterance(utterance)
            }
            catch  {
                // エラー発生してプレイヤー作成失敗
                audioPlayer = nil
                delegate?.updateMusicLabel(item.title ?? "This title")
                delegate?.updateArtistLabel("Cannot Play")
                delegate?.updateDummyArtworkImage()
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "actError", userInfo: nil, repeats: false)
                return false
            }
        }
        else {
            audioPlayer = nil
            delegate?.updateMusicLabel(item.title ?? "This title")
            delegate?.updateArtistLabel("Cannot Play(No URL)")
            delegate?.updateDummyArtworkImage()
            NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "actError", userInfo: nil, repeats: false)
            return false
        }
        return true
    }
    
    func actError(){
        nextItem()
    }
    
    func play(track_number: Int) {
        if 0 <= track_number && track_number < mediaItems.count {
            if updatePlayer(track_number){
                play()
            }
        }
    }
    
    func play() {
        if let player = audioPlayer {
            player.play()
            nowPlaying = true
            // メッセージラベルに再生中アイテム情報を表示
            let item = mediaItems[currentIndex]
            delegate?.updateMusicLabel(item.title ?? "")
            delegate?.updateArtistLabel(item.artist ?? "")
            if(item.artwork != nil){
                delegate?.updateArtworkImage(item.artwork!) //tsuiki1
            } else {
                delegate?.updateDummyArtworkImage() //tsuiki1
            }
            
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
            delegate?.updateDummyArtworkImage()
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
            if(item.artwork != nil){
                delegate?.updateArtworkImage(item.artwork!) //tsuiki1
            }
            else {
                delegate?.updateDummyArtworkImage() //tsuiki1
            }
            currentIndex--
            return
        }
        currentIndex--
        actPlayItem()
    }
    
    private func actPlayItem(){
        if nowPlaying{
            if updatePlayer(currentIndex){
                play()
            }
            else{
                delegate?.updatePlayBtnsTitle("▷")
            }
        }
        else{
            if updatePlayer(currentIndex){
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
            pause()
            delegate?.updateMusicLabel("END")
            delegate?.updateArtistLabel("")
            delegate?.updatePlayBtnsTitle("▷")
            delegate?.updateDummyArtworkImage()
            return
        }
        else {
            nextItem()// 次の曲へ。
        }
    }
    
}

