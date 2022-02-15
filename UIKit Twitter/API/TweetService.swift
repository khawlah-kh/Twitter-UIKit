//
//  TweetService.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 14/02/2022.
//

import UIKit
import Firebase

class TweetService {
    
    static let shared = TweetService()

    func sendTweet(caption:String,completion:@escaping ((Error?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var tweetData :  [String : Any] = [:]
        tweetData["caption"] = caption
        tweetData["uid"] = uid
       
        guard let currentUser = AuthService.shared.user else {return}
        let tweet = Tweet(user: currentUser, dictionary: tweetData)
        
       
        COLECTION_TWEETS.document().setData(tweet.getData()) { error in
            completion(error)
        }
        
    }
    
    
    func fetchTweeets(completion:@escaping (([Tweet]?,Error?)->())){
        
        var tweets = [Tweet]()
        
        COLECTION_TWEETS.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
            }) else {return}

            changes.forEach { change in
                let tweetData = change.document.data()
                print(tweetData)
                guard let tweetUserId  = tweetData["uid"] as? String else {return}
              
                AuthService.shared.fetchtUser(withId: tweetUserId){ user in
                    tweets.append(Tweet(tweetId: change.document.documentID, user: user,dictionary: tweetData))
                    tweets = tweets.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                    completion(tweets,nil)
                   
                }
               
             
            }
         
            
        }
      
        
    }
    
    
    
    
}
