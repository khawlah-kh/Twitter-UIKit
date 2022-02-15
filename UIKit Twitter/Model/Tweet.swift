//
//  Tweet.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 14/02/2022.
//

import Foundation
import Firebase


struct Tweet{
    
    var tweetId: String = ""
   // let username: String
    //let profileImageUrl: String
    //let fullname: String
    let caption: String
    var likes: Int
    var retweet : Int
    let uid: String
    let timestamp: Timestamp
    let user : User
    
    //var replyingTo: String?
        
    init(tweetId:String="",user:User,dictionary: [String: Any]) {
     
        self.tweetId = tweetId
        self.user = user
        
        //self.username = dictionary["username"] as? String ?? ""
       // self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
       // self.fullname = dictionary["fullName"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweet = dictionary["retweet"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
     
    }
    
    func getData ()->[String:Any]{
        var data:[String:Any] = [:]
        data["tweetId"] = self.tweetId
        data["caption"] = self.caption
        data["retweet"] = self.retweet
        data["uid"] = self.uid
        data["timestamp"] = self.timestamp
    
        
        
        return data
        
        
    }
    
    
    
    
    
    
    
    
    
}
