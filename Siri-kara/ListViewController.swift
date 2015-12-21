//
//  ViewController.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//
// receive_param = playlist
// playlist.count  曲数

import UIKit
import MediaPlayer


class ListViewController: UITableViewController {
    
    var receive_param :[MPMediaItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return receive_param.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        cell.textLabel!.text = receive_param[indexPath.row].title! + " | " + receive_param[indexPath.row].artist!
        cell.imageView?.image = getArtworkImage(receive_param[indexPath.row])

        return cell
    }
    
    
    // "https://bitbucket.org/See_Ku/musicplayertips"

    func getArtworkImage(item: MPMediaItem) -> UIImage? {
        // 曲に設定されてるアートワークを取得
        let size = CGSize(width: 40, height: 40)
        if let artwork = item.artwork {
            return artwork.imageWithSize(size)
        }
        return nil
    }
    
    
    
}

