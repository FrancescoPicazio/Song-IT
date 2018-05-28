//
//  SetFrameSize.swift
//  Song-IT
//
//  Created by Francesco Picazio on 17/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit

class SetViewSize: UIViewController {

    @IBOutlet weak var viewSize: UIView!
    
    @IBOutlet var backgroundView: UIView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    self.backgroundView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0, animations: { () -> Void in
            self.backgroundView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
            //SUBVIEW SIZE
            viewSize.frame.size.height = 620
            viewSize.frame.size.width = 540
            viewSize.layer.cornerRadius = 5
            viewSize.layer.masksToBounds = true
        } else {
            viewSize.frame.size.height = view.frame.size.height
            viewSize.frame.size.width = view.frame.size.width
            UIApplication.shared.statusBarStyle = .default  ///change status bar color
            
        }
        viewSize.center.x = view.center.x
        viewSize.center.y = view.center.y
    }

    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //change size when you rotate your phone
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.viewSize.frame.size.height = self.view.frame.size.height
                self.viewSize.frame.size.width = self.view.frame.size.width
            })

            
            viewSize.center.x = view.center.x
            viewSize.center.y = view.center.y
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
