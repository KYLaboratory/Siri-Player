//
//  ViewController.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//

import UIKit
import MediaPlayer


class ListViewController: UITableViewController {
    
    var receive_param :[MPMediaItem] = []
    
    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if receive_param.count > 0{
            let title = receive_param[0].title ?? "no title"
            let artist = receive_param[0].artist ?? "no artist"
            let text = title + " | " + artist
            myLabel.text = text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

