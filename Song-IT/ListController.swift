//
//  ViewController.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 06/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity


class ListController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, DataManagerDelegate , UIViewControllerPreviewingDelegate, WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var backgoundPlusButton: UIImageView!
    
    @IBOutlet weak var backgoroundFilterButton: UIImageView!
    
    @IBOutlet weak var selectMoodButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    
    
    let internetAlert = UIAlertController(title: "No internet connection",
                                          message: "Make sure your device is connected to the internet",
                                          preferredStyle: .alert)
    
    let session = WCSession.default
    
    private let refreshControl = UIRefreshControl()  ///refresh control
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WatchData.shared.inizialize()
        
        let postData = NSKeyedArchiver.archivedData(withRootObject: DataManager.shared.array)
        
        WatchData.shared.applicationContext(iPhoneAppContext: ["posts" : postData])
        
        
        DataManager.shared.delegate = self  ////set the delegate
        DataManager.shared.listCont = self
        checkInternet()
        DataManager.shared.setMood()
        
        setButton()
        
        ////Method that change the background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "sfondo.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.collectionView.backgroundView = backgroundImage
        
        
        ////Configure Refresh Control
        self.collectionView.addSubview(refreshControl)
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 14.0)!] ////White test attribute
        refreshControl.addTarget(self, action: #selector(refreshPostData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString( string : "Fetching Post Data . . ." , attributes: attributes)
        refreshControl.tintColor = UIColor.white
        
        
        ///Configure 3d touch
        self.registerForPreviewing(with: self, sourceView: self.collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.shared.moodArray.count
    }
    
    func setButton(){
        selectMoodButton.layer.cornerRadius = 0.5 * selectMoodButton.frame.width
        
        addButton.layer.cornerRadius = 0.5 * addButton.frame.width
        
        backgoroundFilterButton.backgroundColor = DataManager.shared.colorMood
        
        backgoundPlusButton.backgroundColor = DataManager.shared.colorMood
        
        addButton.layer.cornerRadius = 0.5 * addButton.frame.width
        
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postIt", for: indexPath) as! PostItCollectionViewCell

        //let PostIt = DataManager.shared.array [indexPath.item]
        let PostIt = DataManager.shared.moodArray [indexPath.item]
        
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
        
        ///Deactivate turn button if postit hasn't comment and move the frame of dislike button
        if(cell.front.range(of: "wc") != nil){
            cell.turnButton.isEnabled = false
            cell.dButton.frame.origin = CGPoint(x: 230, y: 227)
            cell.ndislikeLabel.frame.origin = CGPoint(x: 241, y: 264)
        }else{
            cell.turnButton.isEnabled = true
            cell.dButton.frame.origin = CGPoint(x: 177, y: 227)
            cell.ndislikeLabel.frame.origin = CGPoint(x: 186, y: 264)
        }
        
        
        /////Method that set the initial background
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
    
    
    ////Set the function in the delegate
    func didFinishLoadData() {
        
        backgoroundFilterButton.backgroundColor = DataManager.shared.colorMood
        
        backgoundPlusButton.backgroundColor = DataManager.shared.colorMood
        
        self.collectionView.reloadData()
        
        
    }
    
    ///Function in Objective C the should call from the sendler when i call the refresh
    @objc private func refreshPostData(_ sender: Any) {
        fetchPostData()
        self.refreshControl.endRefreshing()

        
       
    }
    
    
    
    ////function the download data from database
    private func fetchPostData() {
        DataManager.shared.loadData()
        
        //Refresh watch
        //let postData =  NSKeyedArchiver.archivedData(withRootObject: DataManager.shared.array)
        
        let postData = NSKeyedArchiver.archivedData(withRootObject: DataManager.shared.array)
        
        WatchData.shared.applicationContext(iPhoneAppContext: ["posts" : postData])
        
        
        DispatchQueue.main.async {
            print("Fetch Data OK")
        }
}
    
    func checkInternet() {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observeSingleEvent(of: .value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
            } else {
                print("Not connected")
                self.internetAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                DataManager.shared.listCont.present(self.internetAlert, animated: true, completion: nil)
            }
        })
    }
    
    
    ////FUNCTION FOR 3DTOUCH
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        print("entrato nel ciclo")
        
        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) as? PostItCollectionViewCell else{
                return nil
        }
        guard let detailViewController =
            storyboard?.instantiateViewController(
                withIdentifier: "detail") as? DetailViewController  else { return nil }
        
        //        detailViewController.view = cell.contentView
        detailViewController.preferredContentSize =
            CGSize(width: 310, height: 300)
        detailViewController.Post = cell.postItModel
        previewingContext.sourceRect = cell.frame
        return detailViewController
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
    }
    
    

    
    
}


  
