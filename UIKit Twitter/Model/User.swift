//
//  User.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 10/02/2022.
//

import Foundation


struct User : Identifiable{
    
    let id :String
    let email : String
    let fullName : String
    let userName : String
    let profileImageUrl : URL

    
    init(data:[String:Any],id:String){

        self.id = (id == "") ? UUID().uuidString : id

        self.fullName = data[User.fullName]  as? String ?? "N/A"
        
        
        self.email = data[User.email]  as? String ?? "N/A"
        
        self.userName = data[User.userName]  as? String ?? "N/A"
        
        let profileImageUrlAsString = data[User.profileImageUrl]  as? String ?? "N/A"
        self.profileImageUrl = URL(string: profileImageUrlAsString)!
        
       
    }
    
    
  
    
    func getUserData()->([String:String]){
        
        var data :[String:String] = [:]
        data[User.fullName]  = self.fullName
        
        
        data[User.email]  = self.email
        
        data[User.userName] = self.userName
        
        data[User.profileImageUrl] = self.profileImageUrl.description
        
        return data
        
    }
    
    static let fullName       = "fullName"
    static let email           = "email"
    static let userName     = "userName"
    static let profileImageUrl = "profileImageUrl"


    
    
}

