//
//  ProfileHeaderViewModel.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 16/02/2022.
//

import UIKit
import Firebase

enum ProfileHeaderOptions : Int , CaseIterable{
    
    case tweets
    case replies
    case likes
    
    var description : String {
        
        switch self{

        case .tweets:
           return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
        
    }
    
    
    
}

enum FollowingFollowers : String {
    case Following,Followers,Follow
    case EditProfile = "Edit Profile"
}


struct ProfileHeaderViewModel{
    
    let user : User
    init(user:User){
        
        
        self.user = user
        
    }
    
    var profileImageUrl : URL {
        return user.profileImageUrl
    }
    
    var fullName : String {
        
        user.fullName
    }
    
    var username : String {
        
        "@\(user.userName)"
    }
    var followingString:NSAttributedString {
        
        
        attributedText(value: user.stats.following, text: FollowingFollowers.Following.rawValue)
        
    }
    
    var followersString:NSAttributedString {
        
        
        attributedText(value: user.stats.followers, text: FollowingFollowers.Followers.rawValue)
        
    }
    
    var actionButtonTitle : String? {

        if user.isCurrentUser {
            return FollowingFollowers.EditProfile.rawValue
        }

        else if user.isFollowed{
            return FollowingFollowers.Following.rawValue
        }
        else{
            return FollowingFollowers.Follow.rawValue
        }
        
    }
    
    func attributedText(value:Int,text:String)->NSAttributedString{
        
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.systemFont(ofSize: 14)
                                                                                   ,.foregroundColor : UIColor.lightGray
                                                                                   ]))

        return attributedTitle
    }
    
    
}
