//
//  UploadTweetControllerViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 13/02/2022.
//

import UIKit

class UploadTweetController: UIViewController {
    
    
    // MARK: Properties

    var user : User
    lazy var  tweetButton : UIButton={
        
        let button = UIButton(type: .system)
        
        button.setTitle("tweet", for: .normal)
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
    
     var captionTextView : UITextView = {
        let textView = CaptionTextView()
         textView.placeholderLabel.text = "What's happining?"
        
        return textView
    }()
    
    
    
    // MARK: Lifecycle
    init(user:User){
        self.user = user
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
        guard let caption = captionTextView.text else {
            print("Please, type something ")
            return}
        TweetService.shared.sendTweet(caption: caption){ error in
            if let error = error {
                print("Something went wrong \(error.localizedDescription)")
            }
            else{
                self.dismiss(animated: true) 
            
            }
        }
      
        
    }
  

    // MARK: API
    // MARK: Helpers
    func confugureUI(){
        view.backgroundColor = UIColor.systemBackground
        
        confugureNavigationBar()
        let stack = UIStackView(arrangedSubviews: [userImage,captionTextView])
        stack.axis = .horizontal
        stack.spacing = 8
        view.addSubview(stack)
    
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 16,paddingRight: 16)
       
      
    }
    
    
    func confugureNavigationBar(){
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target:self, action: #selector(handleCancle))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        
    }
 

}

