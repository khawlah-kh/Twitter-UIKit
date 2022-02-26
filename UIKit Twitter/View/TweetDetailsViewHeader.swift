//
//  CollectionReusableView.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 21/02/2022.
//

import UIKit

protocol TweetDetailsViewHeaderDelegaate : class {
    
    func handelShowActionSheet ()
    
}

class TweetDetailsViewHeader: UICollectionReusableView {
    
    // MARK: - Prperties
    weak var delegate : TweetDetailsViewHeaderDelegaate?
    var tweet : Tweet? {
        didSet{
            configureUI()
        }
    }
    
     var userImage : UIImageView = {
       let image = UIImageView()
       image.backgroundColor = .blue
       image.contentMode = .scaleAspectFill
       image.setDimensions(width: 70, height: 70)
       image.layer.masksToBounds = true
       image.layer.cornerRadius = 70/2
         
         let tap = UITapGestureRecognizer(target: self, action:#selector(handelProfileImageTapped) )
         image.addGestureRecognizer(tap)
         image.isUserInteractionEnabled = true
       
       return image
       
       
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
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
  
    }()
    
    lazy var captionLabel : UILabel = {
        let label = UILabel()
       // label.text = tweet?.caption ?? ""
        label.font=UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
   
    }()
    
    var detailedTweetTimeLabel : UILabel = {
        
        let label = UILabel()
        return label
    }()
    

   lazy var statsView : UIView = {
        let view = UIView()
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1)
        
        
        let retweetsLikesStack = UIStackView(arrangedSubviews: [retweetLabel,likesLabel])
        retweetsLikesStack.axis = .horizontal
        retweetsLikesStack.spacing = 12
       
       view.addSubview(retweetsLikesStack)
       retweetsLikesStack.centerY(inView: view)
       retweetsLikesStack.anchor(left: view.leftAnchor,paddingLeft: 16)
        
       
       let divider2 = UIView()
       divider2.backgroundColor = .systemGroupedBackground

       view.addSubview(divider2)
       divider2.anchor(left: view.leftAnchor, bottom:view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1)
       
        
        return view
    }()
    var retweetLabel : UILabel = {
        let label = UILabel()
//        label.text = "2 following"
//        let tap = UITapGestureRecognizer(target: self, action:#selector(handelFollowingLabelTapped) )
//        label.addGestureRecognizer(tap)
//        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    var likesLabel : UILabel = {
        let label = UILabel()
//        label.text = "2 followers"
//        let tap = UITapGestureRecognizer(target: self, action:#selector(handelFollowersLabelTapped) )
//        label.addGestureRecognizer(tap)
//        label.isUserInteractionEnabled = true
//        
        return label
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        //button.addTarget(self, action: #selector(handelComment), for: .touchUpInside)
        return button
  
    }()
    
   lazy  var retweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
       // button.addTarget(self, action: #selector(handelretweet), for: .touchUpInside)
        return button
  
    }()
    
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
       // button.addTarget(self, action: #selector(handellike), for: .touchUpInside)
        return button
  
    }()
    
    
    lazy var shareButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
       // button.addTarget(self, action: #selector(handelShare), for: .touchUpInside)
        return button
  
    }()
    
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handelProfileImageTapped(){}
    
    @objc func showActionSheet(){
        
        self.delegate?.handelShowActionSheet()
        
    }
    
    // MARK: - Helpers
    func configureUI(){

        guard let tweet = tweet else {
            return
        }
        let viewModel = TweetDetailsViewModel(tweet: tweet)
        userImage.sd_setImage(with: viewModel.profileImageUrl)
        addSubview(userImage)
        
        userImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
        
        let usernameStack = UIStackView(arrangedSubviews: [fullNameLabel,usernameLabel])
        usernameStack.axis = .vertical
        usernameStack.spacing = 2
        usernameStack.distribution = .fillEqually
        usernameStack.alignment = .leading
        
        addSubview(usernameStack)
        usernameStack.anchor(top: topAnchor, left: userImage.rightAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 24, paddingRight: 16)
        
        captionLabel.text=viewModel.caption
        detailedTweetTimeLabel.attributedText = viewModel.detailedTweetTime
        retweetLabel.attributedText = viewModel.retweetString
        likesLabel.attributedText = viewModel.likesString
        
        
        let retweetsLikesStack = UIStackView(arrangedSubviews: [retweetLabel,likesLabel])
        retweetsLikesStack.axis = .horizontal
        retweetsLikesStack.alignment = .leading
       // retweetsLikesStack.distribution = .
        retweetsLikesStack.spacing = -8
        
        let actonButtonStack = UIStackView (arrangedSubviews: [commentButton,retweetButton,likeButton,shareButton])
        actonButtonStack.axis = .horizontal
        actonButtonStack.distribution = .fillEqually
        actonButtonStack.alignment = .center
        actonButtonStack.spacing = 72
        
        
        
        addSubview(captionLabel)
        captionLabel.anchor(top: userImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(detailedTweetTimeLabel)
        detailedTweetTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        addSubview(statsView)
        statsView.anchor(top: detailedTweetTimeLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16,height: 40)
        

        
        addSubview(actonButtonStack)
        actonButtonStack.anchor(top: statsView.bottomAnchor, paddingTop: 16)
        actonButtonStack.centerX(inView: self)
      //  actonButtonStack.anchor( bottom: bottomAnchor, paddingBottom: 12)
        
        
        
      
        
    }
}
