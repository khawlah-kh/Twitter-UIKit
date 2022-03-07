//
//  EditProfileHeader.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 07/03/2022.
//

import Foundation
import UIKit

protocol EditProfileHeaderDelegate : class{
    
    func didTabChangeProfilePhoto ()
}
class EditProfileHeader : UIView{
    
    var user : User
    var delegate : EditProfileHeaderDelegate?
    
    
    
    init(user:User){
        
        self.user = user
        super.init(frame: .zero)
       configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
var profileImageView: UIImageView = {
    let profileImageView = UIImageView()
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.clipsToBounds = true
    profileImageView.backgroundColor = .lightGray
    profileImageView.layer.borderColor = UIColor.white.cgColor
    profileImageView.layer.borderWidth = 3.0
    profileImageView.setDimensions(width: 100, height: 100)
    profileImageView.layer.cornerRadius = 100 / 2
    return profileImageView
    
}()
    
    
    private var changePhotoButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handelChangeProfilePhoto), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()

    
    //MARK: - Selectors
    @objc func handelChangeProfilePhoto(){
        delegate?.didTabChangeProfilePhoto()
        
        
    }
    
    
    //MARK: - Helpers
    func configureUI(){
        backgroundColor = .twitterBlue
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)

        
        
    }
}
