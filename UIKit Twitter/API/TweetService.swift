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

    func sendTweet(caption:String,config:UploadTweetConfiguration,completion:@escaping ((Error?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var tweetData :  [String : Any] = [:]
        tweetData["caption"] = caption
        tweetData["uid"] = uid
       
        guard let currentUser = AuthService.shared.user else {return}
        let tweetOrReply = Tweet(user: currentUser, dictionary: tweetData)
        

        switch config {
        case .tweet:
            uploadTweet()
        case .reply(let tweet):
            uploadReply(tweet: tweet)
            
        }

        // Case : Tweet
        func uploadTweet(){
            let document =   COLECTION_TWEETS.document()
            document.setData(tweetOrReply.getData()) { error in
            
                if let error = error {completion(error)
                    return
                }
                COLECTION_USER_TWEETS.document(uid).collection(tweetsCollection).document(document.documentID).setData([ :]) { error in
                    completion(error)
                }
    
            }
        }
        
        // Case : Reply
        func uploadReply(tweet : Tweet){
            let document =   COLECTION_TWEET_REPLIES.document(tweet.tweetId)
            document.collection(repliesCollection).document().setData(tweetOrReply.getData()){ error in
                print("\(tweetOrReply.caption)🌹")
                completion(error)
            }
            
            
        }
    }
    
    typealias completion = (([Tweet]?,Error?)->())
    

    
    
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
    

    
    
// For test
    func fetchTweeets2(completion:@escaping completion){
        
        var tweetsID = [String]()
        
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
      
        
        
//        var tweets = [Tweet]()
//        COLECTION_TWEETS.getDocuments { snapshot, error in
//            if let error = error {
//                completion(nil,error)
//                return
//            }
//
//            guard let snapshot = snapshot else {return }
//
//            snapshot.documents.forEach { tweet in
//                let tweetData = tweet.data()
//                guard let tweetUserId  = tweetData["uid"] as? String else {return}
//                AuthService.shared.fetchtUser(withId: tweetUserId){ user in
//                    tweets.append(Tweet(tweetId: tweet.documentID, user: user,dictionary: tweetData))
//                    tweets = tweets.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
//                    completion(tweets,nil)
//
//                }
//
//            }
//
//        }
     
        
        
        
     
      
        
    }
    
    
    
    
    func fetchReplies (for tweetId : String,completion:@escaping completion ){
        
        var replies = [Tweet]()
        COLECTION_TWEET_REPLIES.document(tweetId).collection(repliesCollection).getDocuments { snapshot, error in
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach { tweet in
                let tweetData = tweet.data()
                guard let tweetUserId  = tweetData["uid"] as? String else {return}
                
                  AuthService.shared.fetchtUser(withId: tweetUserId){ user in
                      replies.append(Tweet(tweetId:tweet.documentID, user: user,dictionary: tweetData))
                      replies = replies.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                      completion(replies,nil)
                     
                  }
               
                    
                }
                
            }
            
            
        }
        
        
        
        
        
    }




