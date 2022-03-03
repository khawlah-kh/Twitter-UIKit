//
//  Tweet.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 14/02/2022.
//

import Foundation
import Firebase


struct Tweet{
    
    
    static let MockData = Tweet(dictionary: ["fullName" : "Khalid",
                                             "userName":"kkhh",
                                             "uid": "12345",
                                             "caption" : "test test test"
                                            ])
    
    var tweetId: String = ""
    let caption: String
    var likes: Int
    var retweet : Int
    let uid: String
    let timestamp: Timestamp
    var didLike = false
    
    let username: String
    let profileImageUrl: URL
    let fullname: String

        
    init(tweetId:String="",dictionary: [String: Any]) {
     
        self.tweetId = tweetId
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweet = dictionary["retweet"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""

        let profileImageUrlAsString = dictionary[User.profileImageUrl]  as? String ?? "N/A"
        self.profileImageUrl = URL(string: profileImageUrlAsString)!

    }
    
    func getData ()->[String:Any]{
        var data:[String:Any] = [:]
        data[Tweet.tweetId] = self.tweetId
        data[Tweet.caption] = self.caption
        data[Tweet.retweet] = self.retweet
        data[Tweet.likes] = self.likes
        data[Tweet.uid] = self.uid
        data[Tweet.timestamp] = self.timestamp
    
        data[Tweet.fullname] = self.fullname
        data[Tweet.username] = self.username
        data[Tweet.profileImageUrl] = self.profileImageUrl.description
        
         
        return data
        
        
    }
    
    
    
    static let tweetId = "tweetId"
    static let caption = "caption"
    static let retweet = "retweet"
    static let likes = "likes"
    static let uid = "uid"
    static let timestamp = "timestamp"
    static let username = "username"
    static let fullname = "fullname"
    static let profileImageUrl = "profileImageUrl"
    
    
    
    
    
}
