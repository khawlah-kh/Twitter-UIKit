//
//  User.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 10/02/2022.
//

import Foundation
import Firebase


struct User : Identifiable{
    
    let id :String
    let email : String
    var fullName : String
    var userName : String
    var profileImageUrl : URL
    var isFollowed = false
    var stats = UserStats()
    var bio : String?
    
    var isCurrentUser : Bool {
        Auth.auth().currentUser?.uid == self.id
    }

    
    init(data:[String:Any],id:String){

        self.id = (id == "") ? UUID().uuidString : id

        self.fullName = data[User.fullName]  as? String ?? "N/A"
        
        
        self.email = data[User.email]  as? String ?? "N/A"
        
        self.userName = data[User.userName]  as? String ?? "N/A"
        
        let profileImageUrlAsString = data[User.profileImageUrl]  as? String ?? "N/A"
        self.profileImageUrl = URL(string: profileImageUrlAsString)!
        
        
        self.bio = data[User.bio]  as? String
        
       
    }
    
    
  
    
    func getUserData()->([String:String]){
        
        var data :[String:String] = [:]
        data[User.fullName]  = self.fullName
        
        
        data[User.email]  = self.email
        
        data[User.userName] = self.userName
        
        data[User.profileImageUrl] = self.profileImageUrl.description
        data[User.bio] = self.bio ?? ""
        return data
        
    }
    
    static let fullName       = "fullName"
    static let email           = "email"
    static let userName     = "userName"
    static let profileImageUrl = "profileImageUrl"
    static let bio = "bio"


    
    
}


struct UserStats{
    
    
    var followers : Int = 0
    var following : Int = 0
    
    
}
