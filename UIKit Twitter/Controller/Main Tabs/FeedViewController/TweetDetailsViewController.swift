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
    let replies : [Tweet] = [Tweet.MockData,Tweet.MockData,Tweet.MockData]
    
    // MARK: - Lifcycles
    
    init (tweet:Tweet){
        
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureCollectionView()
        
    }
    
    
    // MARK: - Helpers
    func configureCollectionView(){
        
        collectionView.register(TweetDetailsViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tweetDetailsHeaderId)
        collectionView.register(TweetCell.self,forCellWithReuseIdentifier: reusableCellId)
    }


}


// MARK: UICollectionViewDataSource

extension TweetDetailsViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return 3
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
