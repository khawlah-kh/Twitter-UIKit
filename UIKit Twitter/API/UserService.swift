//
//  UserService.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 19/02/2022.
//

import Firebase


class UserService {
    
    static let shared = UserService()
    typealias completion = ()->()
    
    func fetchUsers(completion:@escaping (([User])->Void)){
        
        var users : [User] = []
        COLECTION_USERS.getDocuments { snapshot, error in
            
            //handel error
            
            guard let snapshot = snapshot else {
                print("Somthing went wrong ...")
                return
            }
            
            snapshot.documents.forEach { doc  in
                
                let user = User(data: doc.data(), id: doc.documentID)
                users.append(user)
                completion(users)
            }
            
            
            
            
        }
        

        
    }
    
    func follow(uid:String,completion:@escaping completion){
        
        guard let cuurentUid = Auth.auth().currentUser?.uid else {return}
        let followingRef = COLECTION_FOLLOWING.document(cuurentUid).collection(userFollowingSubCollection)
        
        let followersRef = COLECTION_FOLLOWERS.document(uid).collection(userFollowersSubCollection)
        
        followingRef.document(uid).setData([ : ]) { [self] _ in

            followersRef.document(cuurentUid).setData([ : ]) { _ in
              //is this user is followed by the current user ?
               
                completion()
               // uid.isFollowed = true
                
            }
            
        }
        
        
    }
    
    
    
    func unFollow(uid:String,completion:@escaping completion){
        
        guard let cuurentUid = Auth.auth().currentUser?.uid else {return}
        
        let followingRef = COLECTION_FOLLOWING.document(cuurentUid).collection(userFollowingSubCollection)
        
        let followersRef = COLECTION_FOLLOWERS.document(uid).collection(userFollowersSubCollection)
        
        followingRef.document(uid).delete { _ in
            
            followersRef.document(cuurentUid).delete { _ in
                completion()
               // self.user.isFollowed = false
            }
        }
        
        
        
        
        
    }
    
    
    
    
    func checkIfuserIsFollowed(uid:String,completion:@escaping(((Bool)->Void))){

        guard let cuurentUid = Auth.auth().currentUser?.uid else {return }

        
        guard cuurentUid != uid else {return }
        let followingRef = COLECTION_FOLLOWING.document(cuurentUid).collection(userFollowingSubCollection)

        
        followingRef.document(uid)
            .getDocument { snapshot, _ in

                guard let snapshot = snapshot else {return}
                let isFollowed = snapshot.exists
                completion(isFollowed)
              
               // self.user.isFollowed = isFollowed
      }
      
    }
    
    
    
    func fetchUserStats(uid:String,completion:@escaping(UserStats)->Void){
        
        
        let followingRef = COLECTION_FOLLOWING.document(uid).collection(userFollowingSubCollection)

        let followersRef = COLECTION_FOLLOWERS.document(uid).collection(userFollowersSubCollection)
        
        
        followingRef.getDocuments{ snapshot, _ in
            guard let  NoOfFollowing = snapshot?.documents.count else {return}
        
        followersRef.getDocuments{ snapshot, _ in
            guard let  NoOfFollowers = snapshot?.documents.count else {return}

            let stats = UserStats(followers: NoOfFollowers, following: NoOfFollowing)
            completion(stats)
          
            //self.user.stats =  UserStats(followers: NoOfFollowers, following: NoOfFollowing)
        }
        }
 
        
    }
    
   
}
