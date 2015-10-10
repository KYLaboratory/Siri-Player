//
//  PlayViewController.swift
//  Siri-kara
//
//  Created by Yohei Kato on 2015/10/10.
//  Copyright © 2015年 Yohei Kato. All rights reserved.
//

import UIKit


class PlayViewController: UIViewController {
    
    var receive_param:PLAYLIST_KIND = PLAYLIST_KIND.MAX
    
    @IBOutlet weak var myLabel: UILabel!
    

    @IBAction func goToMusicList(sender: AnyObject) {
         performSegueWithIdentifier("goListViewsegue", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if(segue.identifier == "goListViewsegue"){
            let listViewController:ListViewController = segue.destinationViewController as! ListViewController
            listViewController.receive_param = receive_param
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if receive_param == PLAYLIST_KIND.SIRITORI{
            myLabel.text = "SIRITORI"
        }
        else{
            myLabel.text = "NONE"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

