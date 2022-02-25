//
//  UploadTweetControllerViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 13/02/2022.
//

import UIKit

protocol UploadTweetDelegate : class{
    
    func handleAfterUploading ()
}


class UploadTweetController: UIViewController {
    
    
    // MARK: Properties

    var user : User
    let config : UploadTweetConfiguration
    lazy var viewModel = UploadReplyViewController(config: self.config)

    weak var delegat : UploadTweetDelegate?

    
    lazy var  tweetButton : UIButton={
        
        let button = UIButton(type: .system)
        button.setTitle(viewModel.actionButtonTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .twitterBlue
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
        
    }()
    
    lazy var userImage : UIImageView = {
        let imageURL = user.profileImageUrl
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        //image.clipsToBounds = true
        image.setDimensions(width: 48, height: 48)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 48/2
        image.sd_setImage(with: imageURL, completed: nil)
        
        
        return image
        
        
    }()
    
     lazy var captionTextView : UITextView = {
        let textView = CaptionTextView()
         textView.placeholderLabel.text = viewModel.placeholder
        
        return textView
    }()
    
    lazy var replyLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.attributedText = viewModel.replyText ?? NSAttributedString(string: "", attributes: nil)
        return label
        
    }()
    
    
    // MARK: Lifecycle
    init(user:User,config:UploadTweetConfiguration){
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // title = "Hello"
        confugureUI()
      
    }
    
    //MARK: Selectors
    @objc func handleCancle(){

        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func handleUploadTweet(){
        guard captionTextView.text != ""  else{
            print("Please, type something ")
            return}
        guard let caption = captionTextView.text else {
            print("Please, type something ")
            return}
        TweetService.shared.sendTweet(caption: caption, config: config){ error in
            if let error = error {
                print("Something went wrong \(error.localizedDescription)")
            }
            else{
                    self.delegat?.handleAfterUploading()
                    self.dismiss(animated: true)
                
                
            
            }
        }
      
        
    }
  

    // MARK: API
    // MARK: Helpers
    func confugureUI(){
        
        
        
        view.backgroundColor = UIColor.systemBackground
        confugureNavigationBar()

        
        let imageCaptionstack = UIStackView(arrangedSubviews: [userImage,captionTextView])
        imageCaptionstack.axis = .horizontal
        imageCaptionstack.spacing = 8
        imageCaptionstack.alignment = .leading
        //view.addSubview(imageCaptionstack)
        
        let stack = UIStackView(arrangedSubviews: [replyLabel,imageCaptionstack])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12

        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16,paddingRight: 16)
       
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        
      
    }
    
    
    func confugureNavigationBar(){
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target:self, action: #selector(handleCancle))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        
    }
 

}

