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
    let dummyTitle:String = "unknown Title"
    let dummyArtist:String = "unknown Artist"

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
        
        if receive_param[indexPath.row].title != nil{
            cell.textLabel!.text = receive_param[indexPath.row].title!
        }else{
            cell.textLabel!.text = dummyTitle
        }
        
        if receive_param[indexPath.row].artist != nil{
            cell.detailTextLabel!.text = receive_param[indexPath.row].artist!
        }else{
            cell.detailTextLabel!.text = dummyArtist
        }

        cell.imageView?.image = getArtworkImage(receive_param[indexPath.row])
        return cell
    }
    

    func getArtworkImage(item: MPMediaItem) -> UIImage? {
        // 曲に設定されてるアートワークを取得
        let size = CGSize(width: 100, height: 100)
        if let artwork = item.artwork {
            return artwork.imageWithSize(size)
        } else{
            let dummyImage = UIImage(named: "icon_136700_256.png")
            return dummyImage
        }
        
    }
    
    
    
}

