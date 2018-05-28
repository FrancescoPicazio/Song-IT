//
//  OnboardViewController.swift
//
//  Created by Jay on 10/01/18.
//  Copyright © 2017 giobass_. All rights reserved.
//

import UIKit
import SwiftyOnboard

class OnboardViewController: UIViewController {
    
    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0, green: 0.6901960784, blue: 0.3843137255, alpha: 0.8193658934),#colorLiteral(red: 0.462745098, green: 0.4196078431, blue: 0.6823529412, alpha: 0.75),#colorLiteral(red: 0.9607843137, green: 0.4745098039, blue: 0.3176470588, alpha: 0.79)]
    var titleArray: [String] = ["Welcome to Song-it!", "Share", "Discover"]

    
    var subTitleArray: [String] = ["Music brings us emotions.\nLet the emotions bring you\nsome music!", "Share with others any song that\nyou like and the mood that\ninspire you. Every post\nwill be deleted in 24h.", "Discover new songs and \ndifferent moods.\nTap the stickers to read\ntheir comments,and rate\nthem if you want"]
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 45/255, green: 90/255, blue: 135/255, alpha: 0.82).cgColor
        let purple = UIColor(red: 241/255, green: 109/255, blue: 147/255, alpha: 0.82).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        UIApplication.shared.statusBarStyle = .lightContent
        
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = (self as SwiftyOnboardDataSource)
        swiftyOnboard.delegate = (self as SwiftyOnboardDelegate)
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
        if (index == 2){
            performSegue(withIdentifier: "fromTutorial", sender: UIButton())
        }
    }
}

extension OnboardViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 3
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "HelveticaNeue-Bold", size: 34)
        view.subTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Heavy", size: 16)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continue", for: .normal)
            overlay.skipButton.setTitle("Skip", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Get Started!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}


