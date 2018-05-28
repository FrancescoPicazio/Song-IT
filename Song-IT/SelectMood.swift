//
//  SelectMoodViewController.swift
//  Song-IT
//
//  Created by Francesco Picazio on 29/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit
import Firebase


class SelectMood: UIViewController, DataManagerDelegate {
    
    @IBOutlet weak var titleBar: UINavigationBar!
    
    let internetAlert = UIAlertController(title: "No internet connection",
                                          message: "Make sure your device is connected to the internet",
                                          preferredStyle: .alert)

    
    func didFinishLoadData() {
    }
    
    //    Happy: F4E57A  R: 244, G: 229, B: 122
    //    Relaxed: 00B062  R: 0, G: 176, B: 98
    //    Excited: F57951  R: 245, G: 121, B: 81
    //    Romantic: F16D93  R: 241, G: 109, B: 147
    //    Nostalgic: 766BAE  R: 118, G: 107, B: 174
    //    Angry: F54754  R: 245, G: 71, B: 84
    //    Sad: NEW VALUE , WE NEED TO ADD
    
    //button for select mood the modify the mood in DataManager
    
    @IBAction func angryButton(_ sender: Any) {
        DataManager.shared.mood = "angry"
        DataManager.shared.colorMood = UIColor(red:0.96078, green:0.27843, blue:0.32941, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func excitedButton(_ sender: Any) {
        DataManager.shared.mood = "excited"
        DataManager.shared.colorMood = UIColor(red:0.96078, green:0.47451, blue:0.31765, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func happyButton(_ sender: Any) {
        DataManager.shared.mood = "happy"
        DataManager.shared.colorMood = UIColor(red:0.95686, green:0.89804, blue:0.47843, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nostargicButton(_ sender: Any) {
        DataManager.shared.mood = "nostalgic"
        DataManager.shared.colorMood = UIColor(red:0.46275, green:0.41961, blue:0.68235, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func relaxedButton(_ sender: Any) {
        DataManager.shared.mood = "relaxed"
        DataManager.shared.colorMood = UIColor(red:0.00000, green:0.69020, blue:0.38431, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func romanticButton(_ sender: Any) {
        DataManager.shared.mood = "romantic"
        DataManager.shared.colorMood = UIColor(red:0.94510, green:0.42745, blue:0.57647, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sadButton(_ sender: Any) {
        DataManager.shared.mood = "sad"
        DataManager.shared.colorMood = UIColor(red:0.18, green:0.35, blue:0.53, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func allButton(_ sender: Any) {
        DataManager.shared.mood = "all"
        DataManager.shared.colorMood = UIColor(red:0.93725, green:0.95294, blue:0.95686, alpha:1)
        checkInternet()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add subview with blur
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.view.insertSubview(blurEffectView, at: 0)
        // Do any additional setup after loading the view.
        
        ///Change font and size of navigation bar's title
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 14)!]
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone){
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    
    func checkInternet() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observeSingleEvent(of: .value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                DataManager.shared.loadData() ///LOAD DATA FROM DATABASE
            } else {
                print("Not connected")
                self.internetAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                DataManager.shared.listCont.present(self.internetAlert, animated: true, completion: nil)
            }
        })
    }
    
    
    
}
