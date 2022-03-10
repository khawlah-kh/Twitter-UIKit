//
//  UserCell.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 19/02/2022.
//

import UIKit



class UserCell : UITableViewCell{
    
    
    var user : User?{
        
        didSet{
            configureUI()
        }
    }
    
    
    // MARK: Properties
    var userImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.setDimensions(width: 48, height: 48)
        image.layer.cornerRadius = 48 / 2
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        
        return image
        
    }()
    
    var username : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    var userFullName : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    // MARK: API
    // MARK: Helpers
    func configureUI(){
        
        guard let user = user else {
            return
        }
        
        userImage.sd_setImage(with: user.profileImageUrl)
        addSubview(userImage)
        userImage.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        
        
        username.text = user.userName
        userFullName.text = user.fullName
        
        let stack = UIStackView(arrangedSubviews: [username,userFullName])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 2
        
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: userImage.rightAnchor, paddingLeft: 8)
        
        
    }   
}
