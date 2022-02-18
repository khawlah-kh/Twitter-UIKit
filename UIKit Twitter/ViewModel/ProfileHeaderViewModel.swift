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
    case Following,Followers
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
        
        
        attributedText(value: 2, text: FollowingFollowers.Following.rawValue)
        
    }
    
    var followersString:NSAttributedString {
        
        
        attributedText(value: 2, text: FollowingFollowers.Followers.rawValue)
        
    }
    
    var actionButtonTitle : String? {

        if user.isCurrentUser {
            return "Edit Profile"
        }
        else {
            return "Follow"
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
