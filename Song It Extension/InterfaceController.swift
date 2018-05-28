//
//  InterfaceController.swift
//  Song It Extension
//
//  Created by Francesco Picazio on 05/01/18.
//  Copyright © 2018 Giovanni Bassolino. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate{
    
    static let shared = InterfaceController()
    
    var posts : [PostItModel] = []
    
    @IBOutlet var moodLabel: WKInterfaceLabel!
    @IBOutlet var pickerSequence: WKInterfacePicker!
    var pickerItems: [WKPickerItem] = []
    
    @IBAction func selectedItem(_ value: Int) {
        print("Sequence Picker: \(value) selected")
        
        switch value {
        case 0: pickerSequence.setSelectedItemIndex(8)
            
        case 1:
            moodLabel.setText("All")
            moodLabel.setTextColor(UIColor.white)
            WatchShared.shared.moodSelect = "all"
            
        case 2:
            moodLabel.setText("Happy")
            moodLabel.setTextColor(UIColor(red:0.95686, green:0.89804, blue:0.47843, alpha:1))
            WatchShared.shared.moodSelect = "happy"
            
        case 3:
            moodLabel.setText("Excited")
            moodLabel.setTextColor(UIColor(red:0.96078, green:0.47451, blue:0.31765, alpha:1))
            WatchShared.shared.moodSelect = "excited"
            
        case 4:
            moodLabel.setText("Angry")
            moodLabel.setTextColor(UIColor(red:0.96078, green:0.27843, blue:0.32941, alpha:1))
            WatchShared.shared.moodSelect = "angry"
            
        case 5:
            moodLabel.setText("Romantic")
            moodLabel.setTextColor(UIColor(red:0.94510, green:0.42745, blue:0.57647, alpha:1))
            WatchShared.shared.moodSelect = "romantic"
            
        case 6:
            moodLabel.setText("Nostalgic")
            moodLabel.setTextColor(UIColor(red:0.46275, green:0.41961, blue:0.68235, alpha:1))
            WatchShared.shared.moodSelect = "nostalgic"
            
        case 7:
            moodLabel.setText("Sad")
            moodLabel.setTextColor(UIColor(red:0.18, green:0.35, blue:0.53, alpha:1))
            WatchShared.shared.moodSelect = "sad"
            
        case 8:
            moodLabel.setText("Relaxed")
            moodLabel.setTextColor(UIColor(red:0.00000, green:0.69020, blue:0.38431, alpha:1))
            WatchShared.shared.moodSelect = "relaxed"
            
        case 9:
            pickerSequence.setSelectedItemIndex(1)
            
        default:
            moodLabel.setText("Set mood with crown")
            moodLabel.setTextColor(UIColor.white)
        }
    }
    
    
    var session : WCSession!
    


    
    //Watch Connectivity
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session did complete")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        
        
        
        posts = NSKeyedUnarchiver.unarchiveObject(with: applicationContext["posts"] as! Data) as! [PostItModel]
        
        
        DispatchQueue.main.async {
            print("Posts recived")
            
            print("\(self.posts) recived")
            
            print("\(self.posts.capacity)")
        }
        
        
    }


    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            // Configure interface objects here
            setDataList()
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        super.willActivate()

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}

extension InterfaceController {
    
    // set Data List for Picker Stack.
    func setDataList() {
        pickerItems.append(WKPickerItem())
        for i in 0...7 {
            let item = WKPickerItem()
            item.contentImage = WKImage(imageName: "single\(i)")
            pickerItems.append(item)
        }
        pickerItems.append(WKPickerItem())
        self.pickerSequence.setItems(pickerItems)
        
        self.pickerSequence.setSelectedItemIndex(1)
}
}
