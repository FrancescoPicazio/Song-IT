//
//  PostItModel.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 06/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import Foundation
import Firebase


class PostItModel: NSObject, NSCoding {
    
   
    var title : String
    var artist : String
    var nlike : Int
    var ndislike : Int
    var comment : String
    var mood : String
    var id : String
    var status : Bool?   ////Like/Dislike status, like = true, dilike = false, unvoted = nil
    
    init(title : String , artist : String , nlike: Int , ndislike : Int , comment : String , mood: String, id : String) {
        self.title = title
        self.artist = artist
        self.nlike = nlike
        self.ndislike = ndislike
        self.comment = comment
        self.mood = mood
        self.id = id
    }
    
    //encode system for save post
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.artist, forKey: "artist")
        aCoder.encode(self.nlike, forKey: "nlike")
        aCoder.encode(self.ndislike, forKey: "ndislike")
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.mood, forKey: "mood")
        aCoder.encode(self.id, forKey: "id")
       // aCoder.encode(self.status, forKey: "status")
    }
    
    //decode system for load post
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as? String
        let artist = aDecoder.decodeObject(forKey: "artist") as? String
        let nlike = aDecoder.decodeObject(forKey: "nlike") as? Int
        let ndislike = aDecoder.decodeObject(forKey: "ndislike") as? Int
        let comment = aDecoder.decodeObject(forKey: "comment") as? String
        let mood = aDecoder.decodeObject(forKey: "mood") as? String
        let id = aDecoder.decodeObject(forKey: "id") as? String
      //  let status = aDecoder.decodeObject(forKey: "status") as? Bool

        self.init(title : title! , artist : artist! , nlike: nlike ?? 0, ndislike : ndislike ?? 0 , comment : comment! , mood: mood!, id : id!)
    }
    
}





