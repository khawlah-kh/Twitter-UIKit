//
//  EditProfileViewModel.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 07/03/2022.
//

import Foundation


enum EditProfileOption : Int,CaseIterable{
    
    
    case fullName
    case userName
    case bio
    
    var description : String{
        switch self {
        case .fullName:
            return "Name"
        case .userName:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
    
}
struct EditProfileViewModel {
    
   private var user : User
    let option : EditProfileOption
    init(user:User,option:EditProfileOption){
        self.user = user
        self.option = option
    }
    
    
    
   var shouldHideTextField : Bool{
       
       
       option == .bio
       
   }
    var shouldHideTextView : Bool{
        
        
        option != .bio 

    }

    var cellLabelText : String{
        return option.description
    }
    
    var textFieldText : String{
        switch option {
        case .fullName:
            return user.fullName
        case .userName:
            return user.userName
        case .bio:
            return user.bio ?? "Tell peple something . . . "
        }
    }

    
}
