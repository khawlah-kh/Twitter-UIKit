//
//  ActionSheetViewModel.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 27/02/2022.
//
import UIKit

enum ActionSheetOption  {
    
    
    case follow(User)
    case unfollow(User)
    case delete_tweet
    case report_tweet
    
    var description : String {
        
        
        switch self {
        case .follow(let user):
          return  "Follow @\(user.userName)"
        case .unfollow(let user):
            return "Unfollow @\(user.userName)"
        case .delete_tweet:
            return "Delete Tweet"
        case .report_tweet:
            return "Report Tweet"
        }
        
    }
    
}

class ActionSheetViewModel {
    
    
    var user : User
    init(user:User){
        self.user = user
    }

    //weak var delegate : ActionSheetLauncherDelegate?
    
    var options : [ActionSheetOption] {
        
        var result = [ActionSheetOption]()
        
        if user.isCurrentUser {
            result = [.delete_tweet,.report_tweet]
        }
        else if  user.isFollowed
        {
            result = [.unfollow(user),.report_tweet]
        }
        else{
            result = [.follow(user),.report_tweet]
        }
        
        return result
    }
    
    
    func performAction (selection : ActionSheetOption,completion:@escaping(()->Void))
    {
        switch selection {
        case .follow(let user):
            UserService.shared.follow(uid: user.id) {
                self.user.isFollowed = true
                completion()
            }
            print("follow")
        case .unfollow(let user):
            UserService.shared.unFollow(uid: user.id) {
                self.user.isFollowed = false
                completion()
            }
            print("unfollow")
        case .delete_tweet:
            print("delete_tweet")
            completion()

        case .report_tweet:
            print("report_tweet")
            completion()

        }
        
        
        
        
        
        
    }

   
}

