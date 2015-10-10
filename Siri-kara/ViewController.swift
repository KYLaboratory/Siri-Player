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

enum PLAYLIST_KIND{
    case GENERATION
    case CATEGORY
    case SIRITORI
    case PLAYNUMBER_ASCENDING
    case PLAYNUMBER_DECENDING
    case MAX
}

class ViewController: UIViewController, MPMediaPickerControllerDelegate, SimplePlayerDelegate {

    var howToMakePlaylist = ["年代", "ジャンル", "曲名しりとり", "再生回数昇順","再生回数降順"]
    let transList = ["ア":"あ", "イ":"い", "ウ":"う", "エ":"え", "オ":"お", "カ":"か", "キ":"き", "ク":"く", "ケ":"け", "コ":"こ", "サ":"さ", "シ":"し", "ス":"す", "セ":"せ", "ソ":"そ", "タ":"た", "チ":"ち", "ツ":"つ", "テ":"て", "ト":"と", "ナ":"な", "ニ":"に", "ヌ":"ぬ", "ネ":"ね", "ノ":"の", "ハ":"は", "ヒ":"ひ", "フ":"ふ", "ヘ":"へ", "ホ":"ほ", "マ":"ま", "ミ":"み", "ム":"む", "メ":"め", "モ":"も", "ヤ":"や", "ユ":"ゆ", "ヨ":"よ", "ラ":"ら", "リ":"り", "ル":"る", "レ":"れ", "ロ":"ろ", "ワ":"わ", "ヲ":"を", "ン":"ん", "ガ":"が", "ギ":"ぎ", "グ":"ぐ", "ゲ":"げ", "ゴ":"ご", "ザ":"ざ", "ジ":"じ", "ズ":"ず", "ゼ":"ぜ", "ゾ":"ぞ", "ダ":"だ", "ヂ":"ぢ", "ヅ":"づ", "デ":"で", "ド":"ど", "バ":"ば", "ビ":"び", "ブ":"ぶ", "ベ":"べ", "ボ":"ぼ", "パ":"ぱ", "ピ":"ぴ", "プ":"ぷ", "ペ":"ぺ", "ポ":"ぽ", "ぁ":"あ", "ぃ":"い", "ぅ":"う", "ぇ":"え", "ぉ":"お", "ゃ":"や", "ゅ":"ゆ", "ょ":"よ", "ァ":"あ", "ィ":"い", "ゥ":"う", "ェ":"え", "ォ":"お", "ャ":"や", "ュ":"ゆ", "ョ":"よ", "a":"A", "b":"B", "c":"C", "d":"D", "e":"E", "f":"F", "g":"G", "h":"H", "I":"I", "j":"J", "k":"K", "l":"L", "m":"M", "n":"N", "o":"O", "p":"P", "q":"Q", "r":"R", "s":"S", "t":"T", "u":"U", "v":"V", "w":"W", "x":"X", "y":"Y", "z":"Z", "、":"", "。":"", "，":"", "．":"", "・":"", "：":"", "；":"", "？":"", "！":"", "゛":"", "゜":"", "´":"", "｀":"", "¨":"", "＾":"", "￣":"", "＿":"", "ヽ":"", "ヾ":"", "ゝ":"", "ゞ":"", "〃":"", "仝":"", "々":"", "〆":"", "〇":"", "ー":"", "―":"", "‐":"", "／":"", "＼":"", "〜":"", "‖":"", "｜":"", "…":"", "‥":"", "‘":"", "’":"", "“":"", "”":"", "（":"", "）":"", "〔":"", "〕":"", "［":"", "］":"", "｛":"", "｝":"", "〈":"", "〉":"", "《":"", "》":"", "「":"", "」":"", "『":"", "』":"", "【":"", "】":"", "＋":"", "−":"", "±":"", "×":"", "÷":"", "＝":"", "≠":"", "＜":"", "＞":"", "≦":"", "≧":"", "∞":"", "∴":"", "♂":"", "♀":"", "°":"", "′":"", "″":"", "℃":"", "￥":"", "＄":"", "¢":"", "£":"", "％":"", "＃":"", "＆":"", "＊":"", "＠":"", "§":"", "☆":"", "★":"", "○":"", "●":"", "◎":"", "◇":"", " ":"", "◆":"", "□":"", "■":"", "△":"", "▲":"", "▽":"", "▼":"", "※":"", "〒":"", "→":"", "←":"", "↑":"", "↓":"", "〓":"", "∈":"", "∋":"", "⊆":"", "⊇":"", "⊂":"", "⊃":"", "∪":"", "∩":"", "∧":"", "∨":"", "¬":"", "⇒":"", "⇔":"", "∀":"", "∃":"", "∠":"", "⊥":"", "⌒":"", "∂":"", "∇":"", "≡":"", "≒":"", "≪":"", "≫":"", "√":"", "∽":"", "∝":"", "∵":"", "∫":"", "∬":"", "Å":"", "‰":"", "♯":"", "♭":"", "♪":"", "†":"", "‡":"", "¶":"", "?":"", "◯":"", "!":"", "#":"", "$":"", "%":"", "&":"", "'":"", "(":"", ")":"", "*":"", "+":"", "":"", "-":"", ".":"", "/":"", ":":"", ";":"", "<":"", "=":"", ">":"", "@":"", "[":"", "]":"", "^":"", "_":"", "`":"", "{":"", "|":"", "}":"", "~":"", "｡":"", "｢":"", "｣":"", "､":"", "･":""]
    
    let player = SimplePlayer()

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var playAndPauseBtn: UIButton!
    
    @IBAction func start(sender: AnyObject) {
        let songQuery = MPMediaQuery.songsQuery()
        if let all_song = songQuery.items as [MPMediaItem]! {
            
            var playlist: [MPMediaItem] = []
            
            // 最初の曲を選択
            let select_first = Int(arc4random_uniform(UInt32(all_song.count)))
            playlist.append(all_song[select_first])
            var pass_char = lastChar(all_song[select_first].title!)
            
            while pass_char != "NO MUSIC" && playlist.count < 101 { // プレイリストの上限は100曲
                // 対応となる曲の洗い出し
                var single_list: [MPMediaItem] = []
                for single in (all_song as [MPMediaItem]!) {
                    
                    var first_char = single.title!.substringToIndex(single.title!.startIndex.advancedBy(1))
                    first_char = checkChar(first_char)
                    
                    if first_char == pass_char {
                        single_list.append(single)
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
                }
            }
            // 確認用（コンソールにプレイリストを出力）
            for single in (playlist as [MPMediaItem]!) {
                let title = single.title ?? "no title"
                let artist = single.artist ?? "no artist"
                let text = title + " | " + artist
                print(text)
            }
            
            // プレイリストの登録
            player.pickItems(playlist)
        }
    }

    // しりとりできる文字かどうかの判定をする関数
    func checkChar(cha: String) -> String {
        if let che = transList[cha] {
            return che
        }
        else {
            return cha
        }
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
            last_char = checkChar(last_char)
        }
        return last_char
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if(segue.identifier == "goListViewsegue"){
            let listViewController:ListViewController = segue.destinationViewController as! ListViewController
            listViewController.receive_param = PLAYLIST_KIND.SIRITORI
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return howToMakePlaylist.count;  // 1列目の選択肢の数
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return howToMakePlaylist[row]  // 1列目のrow番目に表示する値
    }

    // メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // このfunctionを抜けるときにピッカーを閉じる
        defer {
            // ピッカーを閉じ、破棄する
            mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        }
        // プレイヤーにitemをセットして再生
        player.pickItems(mediaItemCollection.items)
    }
    
    // 選択がキャンセルされた場合に呼ばれる
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        // ピッカーを閉じ、破棄する
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pushPlayAndPauseBtn(sender: UIButton) {
        if player.nowPlaying {
            pushPause()
        } else {
            pushPlay()
        }
    }
    
    func pushPlay() {
        player.play()
    }
    
    func pushPause() {
        player.pause()
    }
    
    @IBAction func pushNextBtn(sender: AnyObject) {
        player.nextItem()
    }
    
    @IBAction func pushPrevBtn(sender: AnyObject) {
        player.prevItem()
    }
    
    func updatePlayBtnsTitle(text: String) {
        playAndPauseBtn.setTitle(text, forState: UIControlState.Normal)
    }
    
    func updateMessage(text: String) {
        messageLabel.text = text
    }

}

