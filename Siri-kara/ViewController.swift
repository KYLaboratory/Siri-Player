//
//  ViewController.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//

import UIKit

enum PLAYLIST_KIND{
    case GENERATION
    case CATEGORY
    case SIRITORI
    case PLAYNUMBER_ASCENDING
    case PLAYNUMBER_DECENDING
    case MAX
}

class ViewController: UIViewController {

    var howToMakePlaylist = ["年代", "ジャンル", "曲名しりとり", "再生回数昇順","再生回数降順"]

    
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

}

