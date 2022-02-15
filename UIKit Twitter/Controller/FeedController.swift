//
//  FeedViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit
import SDWebImage

class FeedController : UICollectionViewController{
    

    var tweets : [Tweet]=[]{
        didSet{
            print("????")
            print(tweets.count)
            collectionView.reloadData()
        }
    }
    // MARK: - Properties
    var user : User? {
        didSet{
            configureLeftBarButton()
        }
    }
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftBarButton()
        configureUI()
        fetchTweets ()
       

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
            print("💕")
            print(tweets.count)
        
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
    }
    
    func configureCollectionView(){
        collectionView.register(TweetCell.self,forCellWithReuseIdentifier: reusableCellId)
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
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}


extension FeedController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
        
        
        
    }
    
    
}
