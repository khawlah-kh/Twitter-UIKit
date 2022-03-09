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
    private var selectedFilter : ProfileHeaderOptions = .tweets {
        didSet{
            collectionView.reloadData()
        }
    }
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
    
    var userTweetsAndReplies : [Tweet]=[]{
        didSet{
            collectionView.reloadData()
        }
    }
    var userLikes : [Tweet]=[]{
        didSet{
            collectionView.reloadData()
        }
    }
    var currentDataSource : [Tweet]{
        
        switch selectedFilter {
        case .tweets:
            return userTweets
        case .replies:
            return userTweetsAndReplies
        case .likes:
            return userLikes
        }
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        fetchLikedTweets()
        fetchReplies()
        checkIfUserIsFolowed()
        getUserStates()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    configureCollectionView()
    }
    
    // MARK: Selectors
    
    // MARK: API
    func fetchTweets(){
        TweetService.shared.fetchTweeets(user: user) { tweets in
            self.userTweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets(){
        TweetService.shared.fetchLikes(user: user) { likes in
            self.userLikes = likes
        }
    }
    
    func fetchReplies(){
        TweetService.shared.fetchReplies(user: user) { replies in
            self.userTweetsAndReplies = replies
            self.userTweetsAndReplies.forEach { reply in
            }
            
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
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else {return}
        collectionView.contentInset.bottom = tabBarHeight
        
    }
    
}


// MARK: UICollectionViewDataSource

extension ProfileViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return currentDataSource.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as! TweetCell
        cell.tweet = self.currentDataSource[indexPath.row]
        return cell
        
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetDetailsViewController(tweet: currentDataSource[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
// MARK: Collection View UICollectionViewDelegateFlowLayout


extension ProfileViewController:UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 350)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        let tweet = currentDataSource[indexPath.row]
        let viewmodel = TweetViewModel(tweet: tweet)
        var height = viewmodel.size( forWidth: view.frame.width).height + 90
        if let _ = currentDataSource[indexPath.row].replyingTo {
            height += 20
        }
        return CGSize(width: view.frame.width, height: height)


        
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
  
                    DispatchQueue.main.async {
                        let controller = EditProfileController(user: self.user)
                        controller.delegate = self
                        let nav = UINavigationController(rootViewController:controller )
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    }

            
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
                NotificationService.shared.uploadeNotification(type: .follow, tweet: nil, userId:uid)
    
            }
                
                
                
                
            }
            
        }
        
    func didSelect(filter: ProfileHeaderOptions) {
        self.selectedFilter = filter
    }
    
    }




extension ProfileViewController : EditProfileControllerDelegate{
    func didFinishUpdateProfile(forUser: User) {
        self.user = forUser
        collectionView.reloadData()
    }
    
    
}
