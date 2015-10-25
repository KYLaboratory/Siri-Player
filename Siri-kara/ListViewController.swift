//
//  ViewController.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//

// playlist.count  曲数

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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //debug
        //return myItems.count
        //true
        return receive_param.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //debug
    //private let myItems: NSArray = ["TEST1", "TEST2", "TEST3"]
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        // Cellに値を設定する.
        cell.textLabel!.text = receive_param[indexPath.row].title! + " | " + receive_param[indexPath.row].artist!
        
        //debug
        //cell.textLabel!.text = "\(myItems[indexPath.row])"
        //true
        return cell
    }
    
    
    
    
}

