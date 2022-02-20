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
        

        
        let document =   COLECTION_TWEETS.document()
        document.setData(tweet.getData()) { error in
        
            if let error = error {completion(error)
                return
            }
            COLECTION_USER_TWEETS.document(uid).collection(tweetsCollection).document(document.documentID).setData([ :]) { error in
                completion(error)
            }
            
           
            
            
            
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
                guard let tweetUserId  = tweetData["uid"] as? String else {return}
              
                AuthService.shared.fetchtUser(withId: tweetUserId){ user in
                    tweets.append(Tweet(tweetId: change.document.documentID, user: user,dictionary: tweetData))
                    tweets = tweets.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                    completion(tweets,nil)
                   
                }
               
             
            }
         
            
        }
      
        
    }
    
    
    
    
    
    func fetchTweeets(user:User,completion: @escaping (([Tweet])->())){

        var tweets = [Tweet]()
        COLECTION_USER_TWEETS.document(user.id).collection(tweetsCollection).getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach { doc in
                let tweetId = doc.documentID
                COLECTION_TWEETS.document(tweetId).getDocument { snapshot, error in
                    
                    guard let tweetData = snapshot?.data() else {return}
                    let tweet = Tweet(tweetId: tweetId, user: user, dictionary: tweetData)
                    tweets.append(tweet)
                    completion(tweets)
                    
                }
                
            }
            
            
        }
        
        
    }
    
    
    
   
    
    
}


