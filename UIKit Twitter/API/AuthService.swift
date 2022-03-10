//
//  AuthService.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 10/02/2022.
//

import UIKit
import Firebase

struct AuthCredentials{
    let email:String
    let password:String
    let fullName:String
    let userName:String
    let profileImage:UIImage
    
}


class AuthService{
    
    static let shared = AuthService()

    var user : User? = nil
    func creatUser(credentials:AuthCredentials, completion:@escaping ((Error?)->())){
        
        var userData : [String:String] = [User.email:credentials.email
                                          ,User.fullName:credentials.fullName
                                          ,User.userName:credentials.userName.lowercased()
                                          ,User.profileImageUrl:""]
        
        Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
            
            if let error = error{
                print(error.localizedDescription)
                //self.alertItem=AlertContext.createProfileFailure
                //self.hideLoadingView()
                return
            }
            else{
                print("Successfully create user")
                
                // let user = User(data: userData, id: result?.user.uid ?? "")
            }
            persistImageToStorage()
        }
        
        func persistImageToStorage() {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let ref = Storage.storage().reference(withPath: uid)
            
            guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.5) else { return }
            
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    // self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                    print("Failed to push image to Storage: \(err)")
                    return
                }
                
                ref.downloadURL { url, err in
                    if let err = err {
                        print("Failed to retrieve downloadURL: \(err)")
                        return
                    }
                    print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                    print("url for the image :\(url?.absoluteString)")
                    //self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    //self.loginStatusMessage="url for the image :\(url?.absoluteString)"
                    
                    //Complete the process by store user data in firestore
                    guard let url=url else{return}
                    userData[User.profileImageUrl]=url.absoluteString
                    self.storeUserInformation(userData:userData)
                    completion(nil)
                    
                }
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
    func storeUserInformation(userData:[String:String]){
        
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        
        COLECTION_USERS.document(uid).setData(userData) { error in
            if let error = error {
                print(error)
                //self.loginStatusMessage=error.localizedDescription
                return
                
                
            }
            
            print("Sucssessfully added to firestore")
            //AuthViewModel.shared.fetchUser()
            //            AuthViewModel.shared.isAouthenticatting.toggle()
        }
        
        
    }
    
    
    func logUserIn (email : String , password : String,completion:@escaping((Error?)->())){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }
            
            print("Hello 💜",result?.user.uid)
            completion(nil)
            
            
        }
        
    }
    
    func signUserOut(){
        
        do{
            try Auth.auth().signOut()
        }
        catch let error{
            print("Faild to sign user out with error \(error.localizedDescription)")
            
        }
        
        
    }
    
    
    func fetchUser(completion:@escaping((User)->())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        COLECTION_USERS.document(uid).getDocument { snapshot, error in
            
            guard let userData = snapshot?.data() else {return}
            let user =  User(data: userData, id: uid)
            self.user = user
            completion(user)
            print("Hiii 💜\(self.user?.userName)")
    
        }

        
    }
    
    func fetchtUser(withId:String,completion:@escaping((User)->())){
        COLECTION_USERS.document(withId).getDocument { snapshot, error in
            
            guard let userData = snapshot?.data() else {return}
            let user =  User(data: userData, id: withId)
           
            completion(user)
          
    
        }

        
    }
    
    
    
    func fetchtUser(userName:String,completion:@escaping((User)->())){
  
        
        
        COLECTION_USERS.whereField(User.userName, isEqualTo: userName)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let user = User(data: document.data(), id: document.documentID)
                        completion(user)
                    }
                }
        }
        //For now it is a pretty good solution, but it would be better if there is a collection called usernames , where it saves the usernames with the crosponding document id (which leads to the whole document in User collection), that solution will increase the perfomance incredibly. . 
        
    }
    
    
    
    
}
