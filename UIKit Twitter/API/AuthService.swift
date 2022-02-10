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
    func creatUser(credentials:AuthCredentials, completion:@escaping ((Error?)->())){
        
        var userData : [String:String] = [User.email:credentials.email
                                          ,User.fullName:credentials.fullName
                                          ,User.userName:credentials.userName
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
    
}
