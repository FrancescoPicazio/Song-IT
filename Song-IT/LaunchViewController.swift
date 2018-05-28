//
//  LaunchViewController.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 13/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit
import UserNotifications

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            ////Function for fake launch, set the timer
            self.dismiss(animated: true, completion: nil   )
            self.performSegue(withIdentifier: "go", sender: self)
        })
        
        
        //Call Notification request
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (success, error) in
            
            if error != nil {
                print("Notification request denied")
            } else {
                print("Notification request accepted")
            }
        }
    }
}
