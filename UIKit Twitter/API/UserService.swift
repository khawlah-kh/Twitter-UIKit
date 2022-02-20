//
//  UserService.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 19/02/2022.
//

import Firebase


class UserService {
    
    static let shared = UserService()
    
    
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
    
    
    
    
}
