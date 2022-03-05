//
//  NotificationCell.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 04/03/2022.
//

import UIKit


protocol NotificationCellDelegate : class {
    
    func didTapProfileImage(_ cell : NotificationCell)
    func didTapFollow(_ cell : NotificationCell)
    
}

class NotificationCell : UITableViewCell{
    
    
    var notification : Notification?{
        
        didSet{
            configureUI()
        }
    }
    
    weak var delegate : NotificationCellDelegate?
    // MARK: - Properties
     lazy var userImage : UIImageView = {
       let image = UIImageView()
       image.backgroundColor = .blue
       image.contentMode = .scaleAspectFill
       image.setDimensions(width: 48, height: 48)
       image.layer.masksToBounds = true
       image.layer.cornerRadius = 48/2
        
//        let tap = UITapGestureRecognizer(target: self, action:#selector(handelProfileImageTapped) )
//        image.addGestureRecognizer(tap)
//        image.isUserInteractionEnabled = true
        
       return image
       
       
   }()
    lazy var notificationLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "User has started following you "
        return label
  
    }()
    
    var timeLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.setDimensions(width: 64, height: 26)
        button.layer.cornerRadius = 26 / 2
        
        button.addTarget(self, action: #selector(handelFollowTapped), for: .touchUpInside)
        return button
   
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI(){

        guard let notification = notification else {
            return
        }

        let viewModel = NotificationViewModel(notification: notification)
        userImage.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handelProfileImageTapped) )
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
        
        
        
        notificationLabel.attributedText = viewModel.notificationText
        timeLabel.attributedText = viewModel.detailedNotificationTime
        let stack = UIStackView(arrangedSubviews: [userImage,notificationLabel,timeLabel])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center

        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        

        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 16)
        followButton.isHidden = !viewModel.shouldShowFollowButton
        followButton.setTitle(viewModel.followButtonTitle, for: .normal)
        
        
        
        
        

    }
    
    
    // MARK: - Selectors

    @objc func handelProfileImageTapped(){
        self.delegate?.didTapProfileImage(self)

    }
    
    
    @objc func handelFollowTapped(){
        delegate?.didTapFollow(self)
        
    }
}
