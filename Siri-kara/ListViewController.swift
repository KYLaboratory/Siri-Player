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
    
//    @IBOutlet weak var myLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if receive_param.count > 0{
            let title = receive_param[0].title ?? "no title"
            let artist = receive_param[0].artist ?? "no artist"
            let text = title + " | " + artist
            myLabel.text = text
        }*/
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return receive_param.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 再利用するCellを取得する.
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell", forIndexPath: indexPath)
        // Cellに値を設定する.
        cell.textLabel!.text = receive_param[indexPath.row].title! + " | " + receive_param[indexPath.row].artist!
        //cell.textLabel?.text = receive_param[indexPath.row].title
        //cell.detailTextLabel?.text = "\(receive_param[indexPath.row].artist) - \(receive_param[indexPath.row].albumTitle)"
        cell.imageView?.image = getArtworkImage(receive_param[indexPath.row])

        return cell
    }
    
    
    // "https://bitbucket.org/See_Ku/musicplayertips"
    /// アートワークで使用するイメージを取得
    func getArtworkImage(item: MPMediaItem) -> UIImage? {
        
        /*
        // 再生中の曲の場合は専用のイメージを返す
        if g_musicPlayer.nowPlayingItem == item {
            return UIImage(named: "playing")
        }*/
        
        // 曲に設定されてるアートワークを取得
        let size = CGSize(width: 40, height: 40)
        if let artwork = item.artwork {
            return artwork.imageWithSize(size)
        }
        
        return nil
    }
    
    
    
}

