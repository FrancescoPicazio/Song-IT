//
//  ListInterfaceController.swift
//  Song-IT
//
//  Created by Francesco Picazio on 17/01/18.
//  Copyright © 2018 Giovanni Bassolino. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ListInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var table: WKInterfaceTable!
    
    var posts : [PostItModel] = []
    
    var postsMood : [PostItModel] = []
    
    //Watch Connectivity
    var session : WCSession!
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session did complete")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        //posts = applicationContext["posts"] as! [PostItModel]
        posts = NSKeyedUnarchiver.unarchiveObject(with: applicationContext["posts"] as! Data) as! [PostItModel]
        
        print("Posts recived")
        
        
        DispatchQueue.main.async {
            
            print("\(self.posts) recived")
            print("\(self.posts.capacity)")
        }
    }
    
    func backgroundColor(mood: String) -> UIColor {
        switch mood {
        case "angry":
            return UIColor(red:0.96078, green:0.27843, blue:0.32941, alpha:1)
        case "excited":
            return UIColor(red:0.96078, green:0.47451, blue:0.31765, alpha:1)
        case "happy":
            return UIColor(red:0.95686, green:0.89804, blue:0.47843, alpha:1)
        case "nostalgic":
            return UIColor(red:0.46275, green:0.41961, blue:0.68235, alpha:1)
        case "relaxed":
            return UIColor(red:0.00000, green:0.69020, blue:0.38431, alpha:1)
        case "romantic":
            return UIColor(red:0.94510, green:0.42745, blue:0.57647, alpha:1)
        case "sad":
            return UIColor(red:0.18, green:0.35, blue:0.53, alpha:1)
        default:
            return UIColor.white
        }
    }
    
    
    func setupTable() {
        
        if posts.isEmpty {
            table.setNumberOfRows(1, withRowType: "postRow")
            
            let color = backgroundColor(mood: WatchShared.shared.moodSelect)
            
            if let row = table.rowController(at: 0) as? PostRow {
                row.songTitle.setText("No post loaded")
                row.artistName.setText("prease refresh the app")
                row.nlike.setText("")
                row.ndislike.setText("")
                
                row.backgorund.setBackgroundColor(color)
            }
        } else {
            table.setNumberOfRows(postsMood.count, withRowType: "postRow")
            for post in postsMood {
                let color = backgroundColor(mood: post.mood)
                if let row = table.rowController(at: 0) as? PostRow {
                    row.songTitle.setText(post.title)
                    row.artistName.setText(post.artist)
                    row.nlike.setText(String(post.nlike))
                    row.ndislike.setText(String(post.ndislike))
                    row.backgorund.setBackgroundColor(color)
                }
            }
        }
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
        if WatchShared.shared.moodSelect == "all" {
            postsMood = posts
        } else {
            for post in posts {
                if post.mood == WatchShared.shared.moodSelect {
                    postsMood.append(post)
                }
            }
        }
        
        setupTable()
        
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
