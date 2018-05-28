//
//  DetailViewController.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 22/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit
import Mailgun_In_Swift

class DetailViewController: UIViewController,  UICollectionViewDataSource , UICollectionViewDelegate {
    
    let mailgun = MailgunAPI(apiKey: "key-25d7c148a4bd7018a79fb7fb0eef4d0e", clientDomain: "sandbox66c745c415b44adda45538d631461167.mailgun.org")
    
    var index : Int?
    var Post : PostItModel?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postIt", for: indexPath) as! PostItCollectionViewCell
        
        let PostIt = Post!
        
        cell.artistLabel.text = PostIt.artist
        cell.titleLabel.text = PostIt.title
        cell.nlikeLabel.text = String (PostIt.nlike)
        cell.ndislikeLabel.text = String (PostIt.ndislike)
        cell.commentLabel.isHidden = true   //Hide the label
        cell.commentLabel.text = PostIt.comment /// Put the comment in the hide label
        
        cell.postItModel = PostIt
        cell.indexPath = indexPath  ///Save the post it indexT
        
        cell.front = PostIt.mood + ".png"   ///Background front
        cell.back = PostIt.mood + "reverse.png" ////Backgorund back
        
        /////Method that set the initial backgriound
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: cell.front)
        backgroundImage.contentMode = UIViewContentMode.scaleToFill
        cell.backgroundView = backgroundImage
        
        
        ////Set the label state of front Post-it
        cell.commentLabel.isHidden = true
        cell.titleLabel.isHidden = false
        cell.artistLabel.isHidden = false
        cell.nlikeLabel.isHidden = false
        cell.ndislikeLabel.isHidden = false
        cell.lButton.isHidden = false
        cell.dButton.isHidden = false
        
        
        ////Set the buttons inthe right positioning checked if the value exist in the datsbase
        if(cell.postItModel.status == nil){
            cell.lButton.setImage(#imageLiteral(resourceName: "like"), for: UIControlState())
            cell.dButton.setImage(#imageLiteral(resourceName: "dislike"), for: UIControlState())
        }else{
            if(cell.postItModel.status == true){
                cell.lButton.setImage(#imageLiteral(resourceName: "likehigh"), for: UIControlState())
                cell.dButton.setImage(#imageLiteral(resourceName: "dislike"), for: UIControlState())
            }else{
                cell.lButton.setImage(#imageLiteral(resourceName: "like"), for: UIControlState())
                cell.dButton.setImage(#imageLiteral(resourceName: "dislikehigh"), for: UIControlState())
            }
        }
        
        return cell
    }
    
    
    override var previewActionItems: [UIPreviewActionItem] {
        
        let action1 = UIPreviewAction(title: "Report",
                                      style: .destructive,
                                      handler: { previewAction, viewController in
                                        print("Action One Selected")
                                        
                                        self.mailgun.sendEmail(to: "aaa.narcosteam@gmail.com", from: "Report Post <PostReport@song-It.com>", subject: "Report \(self.Post!.id)", bodyHTML: "<p> artist:\(self.Post!.artist)</p> <p>title: \(self.Post!.title) </p>    comment: \(self.Post!.comment)<p>") { mailgunResult in
                                            if mailgunResult.success{
                                                print("Email was sent")
                                            }
                                        }
                                        
                                        
        })
        
        
        let action2 = UIPreviewAction(title: "Cancel",
                                      style: .default,
                                      handler: { previewAction, viewController in
                                        print("Cancel action  Selected")
        })
        
        return [action1, action2]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
