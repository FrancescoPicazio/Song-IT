//
//  PostItCollectionViewCell.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 06/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation



class PostItCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var nlikeLabel: UILabel!
    @IBOutlet weak var ndislikeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var lButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var turnButton: UIButton!
    
    var postItModel: PostItModel!
    var indexPath: IndexPath!
    var audioPlayer = AVAudioPlayer()       ///var that allow play sounds
    
    var front : String = ""
    var back : String = ""
    let deviceID = UIDevice.current.identifierForVendor!.uuidString     ////UUID device
    
    @IBAction func DislikeButton(_ sender: UIButton) {
        DataManager.shared.ref.child(self.postItModel.id).child("id").observeSingleEvent(of: .value, with: { (snapshot) in
            let idPost = snapshot.value as? String
            if idPost == nil {   ////check the post in the database
                DataManager.shared.updateArray(index: self.indexPath.item)
                
                
                let myAlert = UIAlertController(title: "The post doesn't exist anymore",
                                                message: "24 hours have passed since its publication",
                                                preferredStyle: .alert)
                myAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                DataManager.shared.listCont.present(myAlert, animated: true, completion: nil)
            } else {
                self.likeDislike(like: false)
            }
        })
        
    }
    
    
    @IBAction func likeButton(_ sender: Any) {
        DataManager.shared.ref.child(self.postItModel.id).child("id").observeSingleEvent(of: .value, with: { (snapshot) in
            let idPost = snapshot.value as? String
            if idPost == nil { ////ceck the post in the database
                DataManager.shared.updateArray(index: self.indexPath.item)
                
                //insert pop-up error
                let myAlert = UIAlertController(title: "The post doesn't exist anymore",
                                                message: "24 hours have passed since its publication",
                                                preferredStyle: .alert)
                myAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                DataManager.shared.listCont.present(myAlert, animated: true, completion: nil)
                ////
            } else {
                self.likeDislike(like: true)
            }
        })
    }
    
    
    @IBAction func turn(_ sender: UIButton) {  //put animation for the post-it
        play()
        if (self.commentLabel.isHidden == true){
            self.commentLabel.isHidden = false
            self.titleLabel.isHidden = true
            self.artistLabel.isHidden = true
            self.nlikeLabel.isHidden = true
            self.ndislikeLabel.isHidden = true
            self.lButton.isHidden = true
            self.dButton.isHidden = true
            
            UICollectionViewCell.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)  ///set new backgorund
            backgroundImage.image = UIImage(named: self.back)
            backgroundImage.contentMode = UIViewContentMode.scaleToFill
            self.backgroundView = backgroundImage
            
        }else{
            self.commentLabel.isHidden = true
            self.titleLabel.isHidden = false
            self.artistLabel.isHidden = false
            self.nlikeLabel.isHidden = false
            self.ndislikeLabel.isHidden = false
            self.lButton.isHidden = false
            self.dButton.isHidden = false
            
            UICollectionViewCell.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            
            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)      ///set new backgorund
            backgroundImage.image = UIImage(named: self.front)
            backgroundImage.contentMode = UIViewContentMode.scaleToFill
            self.backgroundView = backgroundImage
            
        }
    }
    
    func refreshLikeDislike() { //refresh data
        
        DispatchQueue.main.async {
            DataManager.shared.ref.child(self.postItModel.id).child("nlike").observeSingleEvent(of: .value, with: { (snapshot) in
                let valueLike = snapshot.value as? Int ?? 0
                self.postItModel.nlike = valueLike
            })
            
            DataManager.shared.ref.child(self.postItModel.id).child("ndislike").observeSingleEvent(of: .value, with: { (snapshot) in
                let valueDislike = snapshot.value as? Int ?? 0
                self.postItModel.ndislike = valueDislike
            })
        }
        
        
        
        
    }
    
    func writeLikeDislike() { //write new data
        DataManager.shared.ref.child(self.postItModel.id).updateChildValues(["nlike" : self.postItModel.nlike])
        
        DataManager.shared.ref.child(self.postItModel.id).updateChildValues(["ndislike" : self.postItModel.ndislike])
        
    }
    
    
    func likeDislike(like: Bool){
        let getStatus = self.postItModel.status
        refreshLikeDislike()
        //Set Status
        if getStatus == nil {
            //Inizialize the local value using database
            if like {
                self.postItModel.nlike += 1
                self.lButton.setImage(#imageLiteral(resourceName: "likehigh"), for: UIControlState())
            } else {
                self.postItModel.ndislike += 1
                self.dButton.setImage(#imageLiteral(resourceName: "dislikehigh"), for: UIControlState())
            }
            DataManager.shared.ref.child(self.postItModel.id).child("users").updateChildValues([deviceID : like])
            self.postItModel.status = like
        }
        
        //Delete Status
        if getStatus == like {
            //unceck the like and delete the tuple in the db
            if like {
                self.postItModel.nlike -= 1
                self.lButton.setImage(#imageLiteral(resourceName: "like"), for: UIControlState())
            } else {
                self.postItModel.ndislike -= 1
                self.dButton.setImage(#imageLiteral(resourceName: "dislike"), for: UIControlState())
            }
            DataManager.shared.ref.child(self.postItModel.id).child("users").child(deviceID).removeValue()
            self.postItModel.status = nil
        }
        
        //Modify Status
        if (like != getStatus ?? like){
            //if i check like, unlike must be unchecked
            if like {
                self.postItModel.nlike += 1
                self.postItModel.ndislike -= 1
                self.lButton.setImage(#imageLiteral(resourceName: "likehigh"), for: UIControlState())
                self.dButton.setImage(#imageLiteral(resourceName: "dislike"), for: UIControlState())
            } else {
                self.postItModel.nlike -= 1
                self.postItModel.ndislike += 1
                self.lButton.setImage(#imageLiteral(resourceName: "like"), for: UIControlState())
                self.dButton.setImage(#imageLiteral(resourceName: "dislikehigh"), for: UIControlState())
            }
            DataManager.shared.ref.child(self.postItModel.id).child("users").updateChildValues([deviceID : like])
            self.postItModel.status = like
        }
        self.nlikeLabel.text = String(self.postItModel.nlike)
        self.ndislikeLabel.text = String(self.postItModel.ndislike)
        writeLikeDislike()
    }
    
    
    func play(){        ///function the play the sound
        let flipSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Sounds/pageFlip", ofType: "mp3")!)
        print(flipSound)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        try! AVAudioSession.sharedInstance().setActive(true)
        try! audioPlayer = AVAudioPlayer(contentsOf: flipSound)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    
}
