//
//  ViewController.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

enum PLAYLIST_KIND : Int{
    case GENERATION
    case CATEGORY
    case SIRITORI
    case PLAYNUMBER_ASCENDING
    case PLAYNUMBER_DECENDING
    case MAKE_ANITHING
    case MAX
}

class ViewController: UIViewController, MPMediaPickerControllerDelegate, SimplePlayerDelegate,UIPickerViewDelegate {

    var howToMakePlaylist = ["年代", "ジャンル", "曲名しりとり", "再生回数昇順","再生回数降順","とにかく作成"]
    
    let transList = ["ア":"あ", "イ":"い", "ウ":"う", "エ":"え", "オ":"お", "カ":"か", "キ":"き", "ク":"く", "ケ":"け", "コ":"こ", "サ":"さ", "シ":"し", "ス":"す", "セ":"せ", "ソ":"そ", "タ":"た", "チ":"ち", "ツ":"つ", "テ":"て", "ト":"と", "ナ":"な", "ニ":"に", "ヌ":"ぬ", "ネ":"ね", "ノ":"の", "ハ":"は", "ヒ":"ひ", "フ":"ふ", "ヘ":"へ", "ホ":"ほ", "マ":"ま", "ミ":"み", "ム":"む", "メ":"め", "モ":"も", "ヤ":"や", "ユ":"ゆ", "ヨ":"よ", "ラ":"ら", "リ":"り", "ル":"る", "レ":"れ", "ロ":"ろ", "ワ":"わ", "ヲ":"を", "ン":"ん", "ガ":"が", "ギ":"ぎ", "グ":"ぐ", "ゲ":"げ", "ゴ":"ご", "ザ":"ざ", "ジ":"じ", "ズ":"ず", "ゼ":"ぜ", "ゾ":"ぞ", "ダ":"だ", "ヂ":"ぢ", "ヅ":"づ", "デ":"で", "ド":"ど", "バ":"ば", "ビ":"び", "ブ":"ぶ", "ベ":"べ", "ボ":"ぼ", "パ":"ぱ", "ピ":"ぴ", "プ":"ぷ", "ペ":"ぺ", "ポ":"ぽ", "ぁ":"あ", "ぃ":"い", "ぅ":"う", "ぇ":"え", "ぉ":"お", "ゃ":"や", "ゅ":"ゆ", "ょ":"よ", "ァ":"あ", "ィ":"い", "ゥ":"う", "ェ":"え", "ォ":"お", "ャ":"や", "ュ":"ゆ", "ョ":"よ", "a":"A", "b":"B", "c":"C", "d":"D", "e":"E", "f":"F", "g":"G", "h":"H", "I":"I", "j":"J", "k":"K", "l":"L", "m":"M", "n":"N", "o":"O", "p":"P", "q":"Q", "r":"R", "s":"S", "t":"T", "u":"U", "v":"V", "w":"W", "x":"X", "y":"Y", "z":"Z", "、":"", "。":"", "，":"", "．":"", "・":"", "：":"", "；":"", "？":"", "！":"", "゛":"", "゜":"", "´":"", "｀":"", "¨":"", "＾":"", "￣":"", "＿":"", "ヽ":"", "ヾ":"", "ゝ":"", "ゞ":"", "〃":"", "仝":"", "々":"", "〆":"", "〇":"", "ー":"", "―":"", "‐":"", "／":"", "＼":"", "〜":"", "‖":"", "｜":"", "…":"", "‥":"", "‘":"", "’":"", "“":"", "”":"", "（":"", "）":"", "〔":"", "〕":"", "［":"", "］":"", "｛":"", "｝":"", "〈":"", "〉":"", "《":"", "》":"", "「":"", "」":"", "『":"", "』":"", "【":"", "】":"", "＋":"", "−":"", "±":"", "×":"", "÷":"", "＝":"", "≠":"", "＜":"", "＞":"", "≦":"", "≧":"", "∞":"", "∴":"", "♂":"", "♀":"", "°":"", "′":"", "″":"", "℃":"", "￥":"", "＄":"", "¢":"", "£":"", "％":"", "＃":"", "＆":"", "＊":"", "＠":"", "§":"", "☆":"", "★":"", "○":"", "●":"", "◎":"", "◇":"", " ":"", "◆":"", "□":"", "■":"", "△":"", "▲":"", "▽":"", "▼":"", "※":"", "〒":"", "→":"", "←":"", "↑":"", "↓":"", "〓":"", "∈":"", "∋":"", "⊆":"", "⊇":"", "⊂":"", "⊃":"", "∪":"", "∩":"", "∧":"", "∨":"", "¬":"", "⇒":"", "⇔":"", "∀":"", "∃":"", "∠":"", "⊥":"", "⌒":"", "∂":"", "∇":"", "≡":"", "≒":"", "≪":"", "≫":"", "√":"", "∽":"", "∝":"", "∵":"", "∫":"", "∬":"", "Å":"", "‰":"", "♯":"", "♭":"", "♪":"", "†":"", "‡":"", "¶":"", "?":"", "◯":"", "!":"", "#":"", "$":"", "%":"", "&":"", "'":"", "(":"", ")":"", "*":"", "+":"", "":"", "-":"", ".":"", "/":"", ":":"", ";":"", "<":"", "=":"", ">":"", "@":"", "[":"", "]":"", "^":"", "_":"", "`":"", "{":"", "|":"", "}":"", "~":"", "｡":"", "｢":"", "｣":"", "､":"", "･":"", "～":""]
    
    let player = SimplePlayer()

    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playAndPauseBtn: UIButton!
//    @IBOutlet weak var nextBtn: UIButton!
//    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var albumArtwork: UIImageView!

    let playBtnImage:UIImage? = UIImage(named:"icon_play")
    let pauseBtnImage:UIImage? = UIImage(named:"icon_pause")

    @IBAction func start(sender: AnyObject) {
        makeSiritoriList()
    }
    
    func makeGenerationList(){
        updateMusicLabel("NONE")
        updateArtistLabel("")
    }
    
    func makeCategoryList(){
        updateMusicLabel("NONE")
        updateArtistLabel("")
    }
    
    var playlist: [MPMediaItem] = []
    func makeSiritoriList(){
        playlist.removeAll()
        var listId: Array<UInt64> = []
        //        listId.removeAll()
        let songQuery = MPMediaQuery.songsQuery()
        if let all_song = songQuery.items as [MPMediaItem]! {
            let select_first = Int(arc4random_uniform(UInt32(all_song.count)))// 最初の曲を選択
            playlist.append(all_song[select_first])
            var pass_char = lastChar(all_song[select_first].title!)
            listId.append(all_song[select_first].persistentID)
            //            var pass_char = "る" // テスト用
            
            let playlist_count_max = 100//プレイリストの曲数の上限
            while pass_char != "NO MUSIC" && playlist.count <= playlist_count_max {
                // 対応となる曲の洗い出し
                var single_list: [MPMediaItem] = []
                for single in (all_song as [MPMediaItem]!) {
                    let first_char = firstChar(single.title!)
                    
                    if first_char == pass_char {
                        if !listId.contains(single.persistentID){ // 被り防止判定（リストから被っている曲の除去）
                            single_list.append(single)
                        }
                    }
                }
                // 曲選定と尻（pass_char）の格納
                if single_list.count < 1 {
                    pass_char = "NO MUSIC"
                }
                else {
                    let select_next = Int(arc4random_uniform(UInt32(single_list.count)))
                    playlist.append(single_list[select_next])
                    pass_char = lastChar(single_list[select_next].title!)
                    listId.append(single_list[select_next].persistentID)
                }
            }
            debugPlayList(playlist)// 確認用（コンソールにプレイリストを出力）
            player.pickItems(playlist)// プレイリストの登録
        }
    }
    
    func makePlaynumberAscendingList(){
        updateMusicLabel("NONE")
        updateArtistLabel("")
    }
    
    func makePlaynumberDecendingList(){
        updateMusicLabel("NONE")
        updateArtistLabel("")
    }
    
    func makeAnyList(){
        updateMusicLabel("NONE")
        updateArtistLabel("")
    }
    
    func debugPlayList(playlist: [MPMediaItem]){
        for single in (playlist as [MPMediaItem]!) {
            let title = single.title ?? "no title"
            let artist = single.artist ?? "no artist"
            let text = title + " | " + artist
            print(text)
        }
    }
    
    // しりとりできる文字に変換する関数
    func convertToSiritoriChar(cha: String) -> String {
        if let che = transList[cha] {
            return che
        }
        else {
            return cha
        }
    }
    
    // 文字列の最初の文字（頭文字）を取り出す関数
    func firstChar(text: String) -> String {
        var text_temp = text
        var first_char = ""
        //        var first_char_num = 0
        
        // しりとりできる文字を見つけるまで繰り返し
        while first_char == "" && text_temp.characters.count > 0 {
            //            first_char_num++
            first_char = text_temp.substringToIndex(text_temp.startIndex.advancedBy(1))
            text_temp = text_temp.substringFromIndex(text_temp.startIndex.advancedBy(1))
            first_char = convertToSiritoriChar(first_char)
        }
        return first_char
    }
    
    // 文字列の最後の文字（尻文字）を取り出す関数
    func lastChar(text: String) -> String {
        var text_temp = text
        var last_char = ""
        var last_char_num = text.characters.count
        
        // しりとりできる文字を見つけるまで繰り返し
        while last_char == "" && last_char_num > 0 {
            last_char_num--
            last_char = text_temp.substringFromIndex(text_temp.startIndex.advancedBy(last_char_num))
            text_temp = text.substringToIndex(text.startIndex.advancedBy(last_char_num))
            last_char = convertToSiritoriChar(last_char)
        }
        return last_char
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if(segue.identifier == "goListViewsegue"){
            let listViewController:ListViewController = segue.destinationViewController as! ListViewController
            listViewController.receive_param = playlist
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        //playAndPauseBtn.setImage(playBtnImage!, forState: .Normal)
        updateDummyArtworkImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // このfunctionを抜けるときにピッカーを閉じる
        defer {
            mediaPicker.dismissViewControllerAnimated(true, completion: nil)// ピッカーを閉じ、破棄する
        }
        player.pickItems(mediaItemCollection.items)// プレイヤーにitemをセットして再生
        
    }
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)// ピッカーを閉じ、破棄する
    }
    
    @IBAction func pushPlayAndPauseBtn(sender: UIButton) {
        if player.nowPlaying {
            player.pause()
        }
        else {
            player.play()
        }
    }
    
    @IBAction func pushNextBtn(sender: AnyObject) {
        player.nextItem()
    }
    
    @IBAction func pushPrevBtn(sender: AnyObject) {
        player.prevItem()
    }
    
    func updatePlayBtnsTitle(text: String) {
        if text == "▷"{
            playAndPauseBtn.setImage(playBtnImage, forState: UIControlState.Normal)
        }else if text == "||"{
            playAndPauseBtn.setImage(pauseBtnImage, forState: UIControlState.Normal)
        }
        //playAndPauseBtn.setTitle(text, forState: UIControlState.Normal)
    }
    
    func updateMusicLabel(text: String) {
        musicLabel.text = text
    }
    
    func updateArtistLabel(text: String){
        artistLabel.text = text
    }
    
    
    func updateArtworkImage(Artwork: MPMediaItemArtwork){
        let size = CGSize(width: 200, height: 200)
            albumArtwork.image = Artwork.imageWithSize(size)
        }
    
    func updateDummyArtworkImage(){
        let dummyImage = UIImage(named: "icon_136700_256.png")
        //関係ない画像を入れる
        albumArtwork.image = dummyImage
        } // アートワークがない曲の記述をする。エラー処理でダミー画像を挟む。if else文で。
    
    //バックグラウンドで連続再生するためにイベントを最初に受け取るファーストレスポンダにする
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    //Viewの表示、非表示のタイミングでファーストレスポンダの登録と解除を行う
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignFirstResponder()
    }
}

