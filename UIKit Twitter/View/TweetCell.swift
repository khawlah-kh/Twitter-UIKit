//
//  TweetCell.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 14/02/2022.
//

import UIKit
import SwiftUI


class TweetCell:UICollectionViewCell {
    
    
    // MARK: Properties
    lazy var userImage : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.contentMode = .scaleAspectFill
        //image.clipsToBounds = true
        image.setDimensions(width: 48, height: 48)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 48/2
        //image.sd_setImage(with: imageURL, completed: nil)
        
        
        return image
        
        
    }()
    
    var captionLabel : UILabel = {
        let label = UILabel()
        label.text = "Test Test Test Test Test Test Test Test "
        label.font=UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
        
        
    }()
    
    var infoLabel : UILabel = {
        
        let label = UILabel()
        label.text = "Khawlah @khawlah34"
        label.font=UIFont.systemFont(ofSize: 14)
      
        return label
        
        
    }()
    
    var divider : UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground

        return divider
        
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handelComment), for: .touchUpInside)
        return button
  
    }()
    
   lazy  var retweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handelretweet), for: .touchUpInside)
        return button
  
    }()
    
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handellike), for: .touchUpInside)
        return button
  
    }()
    
    
    lazy var shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(handelShare), for: .touchUpInside)
        return button
  
    }()
    
    
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(userImage)
        userImage.anchor(top:topAnchor, left: leftAnchor,  paddingTop: 8, paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        stack.axis = .vertical
        addSubview(stack)
        stack.anchor(top: userImage.topAnchor, left: userImage.rightAnchor,right: rightAnchor  ,paddingLeft: 12, paddingRight: 12)
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
       addSubview(divider)
       divider.anchor( left:leftAnchor, bottom: bottomAnchor,right:rightAnchor,height: 1)
        
        let actonButtonStack = UIStackView (arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actonButtonStack.axis = .horizontal
        actonButtonStack.distribution = .fillEqually
        actonButtonStack.spacing = 72
        
        addSubview(actonButtonStack)
        actonButtonStack.centerX(inView: self)
        actonButtonStack.anchor(bottom: bottomAnchor,paddingBottom: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: Selectors
    
    
    @objc func handelComment(){
        print("handelComment")
  
    }
    
    @objc func handellike(){
        print("handellike")
  
    }
    
    @objc func handelretweet(){
        print("handelretweet")
  
    }
    
    @objc func handelShare(){
        print("handelShare")
  
    }
    
    // MARK: Helpers
    
    
    
    
}
