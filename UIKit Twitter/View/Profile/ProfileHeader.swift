//
//  ProfileHeader.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 15/02/2022.
//

import UIKit

protocol ProfileHeaderDelegate : class {
    
    func handelDismissal()
    func handelEditProfileFollow (_ sender : ProfileHeader)
    func didSelect(filter:ProfileHeaderOptions)
}


class ProfileHeader : UICollectionReusableView {
    
    // MARK: Properties
    var user : User? {
        didSet{
            configureUI()
        }
    }
    
   weak var delegate : ProfileHeaderDelegate?
    
    lazy var containerView : UIView = {
        
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.tintColor = .white
        backButton.setDimensions(width: 30, height: 30)
        
        return view
        
        
    }()
    
    var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"),for: .normal)
        
        button.addTarget(self, action: #selector(handelDismissal), for: .touchUpInside)
        return button
        
    }()
    
    var profileImageView : UIImageView = {
        
      let image = UIImageView()
        image.backgroundColor = .cyan
        image.setDimensions(width: 80, height: 80)
        image.layer.cornerRadius = 80 / 2
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.systemBackground.cgColor
        image.layer.borderWidth = 4
        return image
        
        
        
    }()
    
    
    var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.24
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handelEditProfileFollow), for: .touchUpInside)
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2

        return button
        
        
    }()
    
    var fullNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        
        return label
        
    } ()
    
    var usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        
        return label
        
    } ()
    
    var bioLabel : UILabel = {
        let label = UILabel()
        label.text = "Test bio Test bio Test bio Test bio Test bio Test bio Test bio Test bio Test bio Test bio Test bio Test bio "
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        
        return label
        
    } ()
    
    var filterView : ProfileFilterView = {
        
        let filterView = ProfileFilterView()
        
        return filterView
    }()
    
    var followingLabel : UILabel = {
        let label = UILabel()
        label.text = "2 following"
        let tap = UITapGestureRecognizer(target: self, action:#selector(handelFollowingLabelTapped) )
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var followersLabel : UILabel = {
        let label = UILabel()
        label.text = "2 followers"
        let tap = UITapGestureRecognizer(target: self, action:#selector(handelFollowersLabelTapped) )
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
     
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Selectors
    
    @objc func handelDismissal(){
        
        self.delegate?.handelDismissal()
    }
    @objc func handelEditProfileFollow (){
        
        delegate?.handelEditProfileFollow(self)
        
    }
    
    @objc func handelFollowingLabelTapped(){}
    @objc func handelFollowersLabelTapped(){}
    // MARK: API
    
    
    
    // MARK: Helpers
    func configureUI(){
        
        guard let user = user else {return}
        let viewModel = ProfileHeaderViewModel(user: user)

        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,height: 108)
        profileImageView.sd_setImage(with:viewModel.profileImageUrl , completed: nil
        )
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
        bioLabel.text = viewModel.bio
        let userInfoStack = UIStackView(arrangedSubviews: [fullNameLabel,usernameLabel,bioLabel])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillProportionally
        userInfoStack.alignment = .leading
        userInfoStack.spacing = 4
        addSubview(userInfoStack)
        userInfoStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        
        
        
        let followingFollowersStack = UIStackView(arrangedSubviews: [followingLabel,followersLabel])
        followingFollowersStack.axis = .horizontal
        followingFollowersStack.distribution = .fillEqually
        followingFollowersStack.spacing = 8
        
        
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        addSubview(followingFollowersStack)
        followingFollowersStack.anchor(top: userInfoStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        
        
       
        addSubview(filterView)
        filterView.anchor(top: followingFollowersStack.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 20,height: 46)
        filterView.delegate = self
        
     
    }
    
    
    
    
    
}

// MARK: - ProfileFilterViewDelegate
extension ProfileHeader : ProfileFilterViewDelegate{
    func handelFilterSelection(_ view: ProfileFilterView, didSelect index: Int) {
        
        guard let filter = ProfileHeaderOptions(rawValue: index) else {return}
        delegate?.didSelect(filter: filter)
    }
   
}
