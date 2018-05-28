//
//  DataManager.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 06/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

protocol DataManagerDelegate {
    func didFinishLoadData()
}

class DataManager {
    
    
    var delegate: DataManagerDelegate?
    
    let ref = Database.database().reference()
    
    static let shared = DataManager()
    
    var listCont: ListController!
    
    var array : [PostItModel] = [] //Local array that contains the data from database
    
    var moodArray : [PostItModel] = []
    
    var mood: String = "all"
    
    var colorMood : UIColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
    
    func loadData() {
        
        self.array = []
        
        ref.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value){ (snap) in
            
            guard let value = snap.value else {
                print("Il nodo osservato non contiene dati")
                DispatchQueue.main.async {
                    self.setMood()
                    self.delegate?.didFinishLoadData()
                }
                return
            }
            
            guard let dict_value = value as? [String : Any] else {
                print("i dati di \(DataManager.shared.ref.key) non sono un dizionario")
                DispatchQueue.main.async {
                    self.setMood()
                    self.delegate?.didFinishLoadData()
                }
                return
            }
            
            for (_, value) in dict_value.sorted(by: {$0.0 < $1.0}) {
                //print("leggo i valori di: ", value)
                
                
                guard let valore = value as? [String: Any] else {
                    return
                }
                
                let artist = valore["artist"] as! String
                let comment = valore["comment"] as! String
                let mood = valore["mood"] as! String
                let ndislike = valore["ndislike"] as! Int
                let nlike = valore["nlike"] as! Int
                let title = valore["title"] as! String
                let id = valore["id"] as! String
                
                let users = valore["users"] as? [String: Bool]
                
                let myItem = PostItModel(title: title, artist: artist, nlike: nlike, ndislike: ndislike, comment: comment, mood: mood, id: id)
                myItem.status = users?[UIDevice.current.identifierForVendor!.uuidString]
                self.array.insert(myItem, at: 0)
            }
            
            
            self.callNoticication(inSeconds: 3) {(success) in
                if success {
                    print("succefully notified")
                }
            }
            DispatchQueue.main.async {
                self.setMood()
                self.delegate?.didFinishLoadData()
            }
            
        }
    }
    
    
    
    //array of select item by mood
    func setMood() {
        self.moodArray = []
        if mood == "all" {
            self.moodArray = self.array
        } else {
            for post in self.array {
                if post.mood == mood || post.mood == (mood+"wc") {
//                    self.moodArray.insert(post, at: 0)
                    self.moodArray.append(post)
                }
            }
        }
    }
    
    
    
    ///Remove a post in the array and refresh collection
    func updateArray (index : Int){
        self.moodArray.remove(at: index)
        self.delegate?.didFinishLoadData()
    }
    
    
    // method that creates new post
    func newPost(title:String, artist:String, nlike : Int , ndislike : Int ,comment:String, mood:String) {
        let key = ref.childByAutoId().key
        let newElement = ["title" : title , "artist" : artist , "nlike" : nlike , "ndislike" : ndislike , "comment" : comment , "mood" : mood ,"timestamp" : ServerValue.timestamp(), "id" : key] as [String : Any]
        ref.child(key).setValue(newElement)  ///questa mi mena nuovo elemento nel database , una riga
        
        let newPost = PostItModel(title: title, artist: artist, nlike: nlike, ndislike: ndislike, comment: comment, mood: mood, id: key)
        moodArray.insert(newPost, at: 0)
        DispatchQueue.main.async {
            self.delegate?.didFinishLoadData()
        }
    }
    
    
    
    //create notification compary memory stored array and the dba array
    func callNoticication(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) -> ()) {
        var changes = 0
        var isChanged = true
        var repetition = false
        
        if inSeconds > 60 {
            repetition = true
        } else {
            repetition = false
        }
        
        //create a trigger fornotification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: repetition)
        
        let content = UNMutableNotificationContent()
        
        for element in self.array {
            for oldElement in array {
                if oldElement.id == element.id {
                    isChanged = false
                }
            }
            if isChanged { changes += 1 }
            isChanged = true
        }
        
        
        content.title = "New Posts!"
        //content.subtitle = "The desk got \(changes) changes!"
        content.body = "The desk got \(changes) changes!"
        content.categoryIdentifier = "myCategory"
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        if changes > 0 {
            UNUserNotificationCenter.current().add(request) { (error) in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
                
                
            }
        }
        
    }
}


    
    

    


