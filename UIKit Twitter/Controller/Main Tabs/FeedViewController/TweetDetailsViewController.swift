//
//  TweetDetailsViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 21/02/2022.
//

import UIKit

class TweetDetailsViewController: UICollectionViewController {
    
    
    
    // MARK: - Properties
    
    let tweet : Tweet
    var user : User? {
        didSet{
            guard let user = user else {
                return
            }
            actionSheetLauncher=ActionSheetLauncher(user: user)
        }
    }
    var actionSheetLauncher : ActionSheetLauncher?
    var replies : [Tweet]=[]{
        didSet{
            collectionView.reloadData()
            
        }
    }
    
    // MARK: - Lifcycles
    
    init (tweet:Tweet){
        
        self.tweet = tweet
        //self.actionSheet = ActionSheetLauncher(user: <#T##User#>)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchUser()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    // MARK: - Helpers
    func configureCollectionView(){
        
        collectionView.register(TweetDetailsViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tweetDetailsHeaderId)
        collectionView.register(TweetCell.self,forCellWithReuseIdentifier: reusableCellId)
        fetchReplies()
    }
    
    //MARK: API
    func fetchReplies (){
        
        TweetService.shared.fetchReplies(for: tweet.tweetId) { replies, error in
            guard let replies = replies else {
                return
            }
            
            self.replies = replies
        }
        
        
    }
    
    func fetchUser(){
        AuthService.shared.fetchtUser(withId: tweet.uid) { tweetUser in
            // guard let user = tweetUser else {return}
            self.user = tweetUser
            
        }
    }
    
}


// MARK: UICollectionViewDataSource

extension TweetDetailsViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return replies.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as! TweetCell
        cell.tweet = self.replies[indexPath.row]
        return cell
        
        
        
    }
    
    
}

// MARK: CollectionViewDelegate  (Header Function)

extension TweetDetailsViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind:kind, withReuseIdentifier: tweetDetailsHeaderId, for: indexPath) as! TweetDetailsViewHeader
        
        header.tweet = tweet
        header.delegate = self
        
        return header
    }
}


// MARK: Collection View UICollectionViewDelegateFlowLayout


extension TweetDetailsViewController:UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewmodel = TweetViewModel(tweet: tweet)
        let height = viewmodel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)    
        
    }
 
}



// MARK: - TweetDetailsViewHeaderDelegaate

extension TweetDetailsViewController : TweetDetailsViewHeaderDelegaate {
    
    func handelShowActionSheet() {
        
        actionSheetLauncher?.show()
    }
    
    func handelMentionTapped(mentionedUser: User) {
        let controller = ProfileViewController(user: mentionedUser)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
