//
//  ProfileViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 15/02/2022.
//

import UIKit

class ProfileViewController: UICollectionViewController {

    
    
    // MARK: Properties
    private var user : User
    // MARK: Lifecycle
    init(user:User){
        
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    var userTweets : [Tweet]=[]{
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFolowed()
        getUserStates()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Selectors
    
    // MARK: API
    func fetchTweets(){
        TweetService.shared.fetchTweeets(user: user) { tweets in
            self.userTweets = tweets
        }
    }
    
    func checkIfUserIsFolowed(){
        
        UserService.shared.checkIfuserIsFollowed(uid: user.id) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
        
        
    }
    
   func getUserStates(){
       UserService.shared.fetchUserStats(uid: user.id) {stats in
           
           self.user.stats = stats
           
           self.collectionView.reloadData()
       }
    }
    
    // MARK: Helpers
    func configureCollectionView(){
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self,forCellWithReuseIdentifier: reusableCellId)
        
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
    }
    
}


// MARK: UICollectionViewDataSource

extension ProfileViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return userTweets.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as! TweetCell
//        cell.delegat = self
       // if self.userTweets.isEmpty {return cell}
        cell.tweet = self.userTweets[indexPath.row]
        return cell
        
        

    }
    
    
}
// MARK: Collection View UICollectionViewDelegateFlowLayout


extension ProfileViewController:UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: 120)


        
    }


}


// MARK: CollectionViewDelegate  (Header Function)

extension ProfileViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind:kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeader

        
        header.user=self.user
        header.delegate = self
    return header
}
}


// MARK: ProfileHeaderDelegate
extension ProfileViewController : ProfileHeaderDelegate{

    
    func handelDismissal() {
        navigationController?.popViewController(animated: true)
    }
    func handelEditProfileFollow(_ sender: ProfileHeader) {
        
        
        if user.isCurrentUser  {
            print("Show Edit Profile Page")
            return
        }

        
        let uid = self.user.id

         
            if user.isFollowed{
        
                UserService.shared.unFollow(uid: uid){
                    
                    self.user.isFollowed = false
                    self.user.stats.followers -= 1
                    self.collectionView.reloadData()
                    
                }
      
            }
            else {UserService.shared.follow(uid: uid){
                
                self.user.isFollowed = true
                self.user.stats.followers += 1
                self.collectionView.reloadData()
    
            }}
            
        }
        
        
    }


