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

    func fetchTweetForFeed(completion:@escaping (([Tweet]?,Error?)->())){
        
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        var tweets = [Tweet]()
        
        COLECTION_FOLLOWING.document(currentUserId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            if !snapshot.exists{
                completion(tweets, nil)
            }
        }
        
        COLECTION_FOLLOWING.document(currentUserId).collection(userFollowingSubCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
            }) else {return}

            changes.forEach { change in
                let followingId = change.document.documentID
                COLECTION_USER_TWEETS.document(followingId).collection(tweetsCollection).addSnapshotListener { snapshot, error in
                    if let error = error {
                        completion(nil,error)
                        return
                    }
                    guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
                    }) else {return}
                    
                    changes.forEach { change in
                        let tweetIdDoc = change.document
                        let tweetId = tweetIdDoc.documentID
                        self.fetchtTweet(withId: tweetId) { tweet in
                            tweets.append(tweet)
                            completion(tweets,nil)
                            
                            
                            
                        }

                    }
                    
                }
                
             
            }

        }
        
        
        //Current User tweets
        COLECTION_USER_TWEETS.document(currentUserId).collection(tweetsCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
            }) else {return}
            
            changes.forEach { change in
                let tweetIdDoc = change.document
                let tweetId = tweetIdDoc.documentID
                self.fetchtTweet(withId: tweetId) { tweet in
                    tweets.append(tweet)
                    completion(tweets,nil)
                    
                    
                    
                }

            }
            
        }
   
    }

    func sendTweet(caption:String,config:UploadTweetConfiguration,completion:@escaping ((Error?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var tweetData :  [String : Any] = [:]
        tweetData[Tweet.caption] = caption
        tweetData[Tweet.uid] = uid
       
        guard let currentUser = AuthService.shared.user else {return}
       
        tweetData[Tweet.username] = currentUser.userName
        tweetData[Tweet.fullname] = currentUser.fullName
        tweetData[Tweet.profileImageUrl] = currentUser.profileImageUrl.description
        
        let tweetOrReply : Tweet
      

       
        switch config {
        case .tweet:
             tweetOrReply = Tweet( dictionary: tweetData)
        case .reply(let tweet):
            tweetData[Tweet.replyingTo] = tweet.username
            tweetOrReply = Tweet( dictionary: tweetData)
        }
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
                print(" Uploading 🔴")
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
            let document = COLECTION_TWEET_REPLIES.document(tweet.tweetId)
            let replyRef = document.collection(repliesCollection).document()
            replyRef.setData(tweetOrReply.getData()){ error in
                completion(error)
                COLECTION_USER_REPLIES.document(uid).collection(userRepliesCollection).document(tweet.tweetId).setData([tweet.tweetId:replyRef.documentID]){_ in
                    //upload reply notification
                    NotificationService.shared.uploadeNotification(type: .reply, tweet: tweet)
                }
          
            }
            
            
        }
    }
    
    typealias completion = (([Tweet]?,Error?)->())
    

    
    

    
    
    
    
    
    func fetchTweeets(user:User,completion: @escaping (([Tweet])->())){

        var tweets = [Tweet]()
        COLECTION_USER_TWEETS.document(user.id).collection(tweetsCollection).getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach { doc in
                let tweetId = doc.documentID
                self.fetchtTweet(withId: tweetId) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
                
            }
            
            
        }
        
        
    }
    
    func fetchLikes(user:User,completion: @escaping (([Tweet])->())){

        var likes = [Tweet]()
        COLECTION_USER_LIKES.document(user.id).collection(userLikesTweetCollection).getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach { doc in
                let tweetId = doc.documentID
                self.fetchtTweet(withId: tweetId) { tweet in
                    var tweet = tweet
                    tweet.didLike = true
                    likes.append(tweet)
                    completion(likes)
                }
                
            }
            
            
        }
        
        
    }
    
    
    func fetchReplies(user:User,completion: @escaping (([Tweet])->())){

        var replies = [Tweet]()
        COLECTION_USER_REPLIES.document(user.id).collection(userRepliesCollection).getDocuments { snapshot, error in
            
            guard let snapshot = snapshot else {
                return
            }
            snapshot.documents.forEach { doc in
                
                let tweetId = doc.documentID
                guard let replyId = doc.data()[tweetId] as? String else {return}
                COLECTION_TWEET_REPLIES.document(tweetId).collection(repliesCollection).document(replyId).getDocument { snapshot, _ in
                    guard let snapshot =  snapshot?.data() else {return}
                    let reply = Tweet(tweetId: replyId, dictionary: snapshot)
                    replies.append(reply)
                    completion(replies)
                }

            }
            
            
        }
        
        
    }

    func fetchtTweet(withId:String,completion:@escaping((Tweet)->())){
        COLECTION_TWEETS.document(withId).getDocument { snapshot, error in
            
            guard let tweetData = snapshot?.data() else {return}
            let tweet = Tweet(tweetId: withId, dictionary: tweetData)
            completion(tweet)
          
    
        }

        
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
                      replies.append(Tweet(tweetId:tweet.documentID,dictionary: tweetData))
                      replies = replies.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                      completion(replies,nil)
                     
                  }
               
                    
                }
                
            }
            
            
        }
        
        
        
    
    
    func likeTweet(tweet : Tweet , completion : @escaping ()->Void){
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let likes = tweet.likes + 1
        
        //1
        COLECTION_TWEETS.document(tweet.tweetId).updateData(["likes" : likes]){_ in
        
        //2
        COLECTION_USER_LIKES.document(uid).collection(userLikesTweetCollection).document(tweet.tweetId).setData([:]){ _ in
        
        //3
            COLECTION_TWEET_LIKES.document(tweet.tweetId).collection(tweetLikesTweetCollection).document(uid).setData([:]){ _ in
                
                
                
                completion()
            }
        
        }
        
    }
    }
    
    func unLikeTweet(tweet : Tweet , completion : @escaping ()->Void){
        
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let likes = tweet.likes - 1
        
        //1
        COLECTION_TWEETS.document(tweet.tweetId).updateData(["likes" : likes]){_ in
        
        //2
        COLECTION_USER_LIKES.document(uid).collection(userLikesTweetCollection).document(tweet.tweetId).delete{ _ in
            
            //3
            COLECTION_TWEET_LIKES.document(tweet.tweetId).collection(tweetLikesTweetCollection).document(uid).delete
            {_ in
                completion()
            }
        }
        
       
        }
        
        
    }
        
    
    
    func checkIfTweetIsLiked(tweet : Tweet , completion : @escaping (Bool)->Void){
        
        guard let uid = Auth.auth().currentUser?.uid else {return }

        let likesRef = COLECTION_USER_LIKES.document(uid).collection(userLikesTweetCollection)
        
        likesRef.document(tweet.tweetId).getDocument { snapshot, _ in
            
            guard let didLike = snapshot?.exists else {return }
            
            print(didLike,"🤍")
            completion(didLike)
            
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
                    tweets.append(Tweet(tweetId: change.document.documentID,dictionary: tweetData))
                    tweets = tweets.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                    completion(tweets,nil)
                   
                }
             
             
            }
         
           
        }
      

        
        
     
      
        
    }
    
    
    
    
    //Not used yet
    private func fetchUserTweets(withId : String ,completion:@escaping (([Tweet]?,Error?)->())){
        
        var userTweets = [Tweet]()
        COLECTION_USER_TWEETS.document(withId).collection(tweetsCollection).getDocuments { snapshot, error in
            
            guard let snapshot = snapshot?.documents else {return}
            snapshot.forEach {tweetIdDoc in
                
                let tweetId = tweetIdDoc.documentID
                self.fetchtTweet(withId: tweetId) { tweet in
                    userTweets.append(tweet)
                    userTweets = userTweets.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                    completion(userTweets,nil)
                    
                    
                    
                }

            }
            
        }
        
        
        
        
        
    }
    
    // Old fetchTweet
//    func fetchTweeets(completion:@escaping (([Tweet]?,Error?)->())){
//        
//        var tweets = [Tweet]()
//        
//        COLECTION_TWEETS.addSnapshotListener { snapshot, error in
//            if let error = error {
//                completion(nil,error)
//                return
//            }
//            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
//            }) else {return}
//
//            changes.forEach { change in
//                let tweetData = change.document.data()
//                tweets.append(Tweet(tweetId: change.document.documentID,  dictionary: tweetData))
//             
//            }
//            tweets = tweets.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
//            completion(tweets,nil)
//
//         
//           
//        
//        }
//        
//    }
    }






