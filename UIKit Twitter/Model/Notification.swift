//
//  Notification.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 03/03/2022.
//

import Foundation
import Firebase


enum NotificationType : Int{
    case follow
    case like
    case reply
    case retweet
    case mention
    
    
    
}

struct Notification {
    
    var type : NotificationType!
    
    let tweetId : String?
    var tweet : Tweet?
    
    var timestamp: Timestamp
    var user : User
    
   
   
    
    init(user:User,tweet:Tweet?=nil,dictionary:[String:Any]){
        
       
        
        self.user = user
        self.tweet=tweet
        
        self.tweetId = dictionary[Notification.tweetId] as? String
        self.timestamp = dictionary[Notification.timestamp] as? Timestamp ?? Timestamp(date: Date())
        guard let type = dictionary[Notification.type] as? Int else {return}
        self.type = NotificationType(rawValue: type)
        
        
  
        
    }

    
    
    
    
    static let tweetId = "tweetId"
    static let timestamp = "timestamp"
    static let type = "type"
    
    
}
