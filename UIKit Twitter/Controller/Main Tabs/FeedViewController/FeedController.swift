//
//  FeedViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit
import SDWebImage
import CoreMIDI

class FeedController : UICollectionViewController{
    

    var tweets : [Tweet]=[]{
        didSet{
                self.collectionView.reloadData()
            
            
        }
    }
    // MARK: - Properties
    var user : User? {
        didSet{
            configureLeftBarButton()
        }
    }
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(actionButonTapped), for: .touchUpInside)
        return button
    }()
    
    
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftBarButton()
        configureUI()
        fetchTweets ()
       

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.barStyle = .default
    }
    
    
    //MARK: - Selectors
    @objc func actionButonTapped(){
        guard let user = user else {return}
        let controller =  UploadTweetController(user: user, config: .tweet)
        controller.delegat = self
        let nav = UINavigationController(rootViewController:controller )

        present(nav , animated: true, completion: nil)
        
    }
    
    // MARK: API
    func fetchTweets(){
        TweetService.shared.fetchTweeets { tweets, error in
            
            if let error = error {
                print("Something went wrong!\(error.localizedDescription)")
                return
            }
            guard let tweets = tweets else {
                return
            }

            self.tweets = tweets
            
            // Check Liked Tweet
            for (index , tweet) in tweets.enumerated(){
                
                TweetService.shared.checkIfTweetIsLiked(tweet: tweet) { isLiked in
                    guard isLiked == true else {return}
                    self.tweets[index].didLike = isLiked
                }
                
            }
        }
        
        
        
    }
    // MARK: - Helper Functions
    
    func configureUI(){

        configureCollectionView()
        view.backgroundColor = UIColor.systemBackground
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        
        configureActionButton()
 
    }
    
    func configureCollectionView(){
        collectionView.register(TweetCell.self,forCellWithReuseIdentifier: reusableCellId)
    }
    
    func configureActionButton(){
        
        view.addSubview(actionButton)

        actionButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, right:view.rightAnchor,  paddingBottom: 32, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
    }
    
    func configureLeftBarButton(){
        
        guard let user = user else {return}
        let userImgeView = UIImageView()
        userImgeView.setDimensions(width: 32, height: 32)
        userImgeView.layer.cornerRadius = 32 / 2
        userImgeView.layer.masksToBounds = true
        let imageURL = user.profileImageUrl
        userImgeView.sd_setImage(with: imageURL,completed: nil)
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userImgeView)

    }
}



extension FeedController {
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as! TweetCell

        DispatchQueue.main.async {

            cell.tweet = self.tweets[indexPath.row]
            cell.delegat = self
        }
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
        let controller = TweetDetailsViewController(tweet:tweets[indexPath.row])

        controller.navigationItem.title = "Tweet"
        navigationController?.pushViewController(controller, animated: true)
        
    }
}


extension FeedController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = tweets[indexPath.row]
        let viewmodel = TweetViewModel(tweet: tweet)
        let height = viewmodel.size( forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height+90)
        
        
        
    }
    
    
}


// MARK: - TweetCellDelegate
extension FeedController : TweetCellDelegate{
 
    func handelLikeTweet(_ cell: TweetCell) {
        guard let  tweet = cell.tweet else {
                return
            }
        print(tweet.didLike,"🔴")
            if tweet.didLike {
                TweetService.shared.unLikeTweet(tweet:tweet) {
                    cell.tweet?.didLike = false
                    print(cell.tweet?.didLike,"🔴🔴")
                    let likes = tweet.likes - 1
                    cell.tweet?.likes = likes
                }
                
            }
            else{
                TweetService.shared.likeTweet(tweet:tweet) {
                    cell.tweet?.didLike = true
                    print( cell.tweet?.didLike,"🔴🔴")
                    let likes = tweet.likes + 1
                    cell.tweet?.likes = likes
                    
                    guard let tweet = cell.tweet else {return}
                    guard tweet.didLike else {return}
                    NotificationService.shared.uploadeNotification(type: .like, tweet: tweet)

               
            }
            }
        
        
    }
    
  
    func handelProfileImageTapped(_ cell: TweetCell) {
        guard let  userID = cell.tweet?.uid else {
            return
        }
        AuthService.shared.fetchtUser(withId: userID) { tweetUser in
            let controller = ProfileViewController(user: tweetUser)
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
    }
    func handelRetweetTapped(_ cell: TweetCell) {
        
     
        guard let tweet = cell.tweet else {return}
        guard  let currentUser = AuthService.shared.user else {return}
        let controller = UploadTweetController(user: currentUser, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)

    }
    
    
}


// MARK: UploadTweetDelegate
extension FeedController : UploadTweetDelegate{
    func handleAfterUploading() {
    
            self.fetchTweets()

    }
   
}
