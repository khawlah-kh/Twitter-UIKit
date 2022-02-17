//
//  ProfileViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 15/02/2022.
//

import UIKit

class ProfileViewController: UICollectionViewController {

    
    
    // MARK: Properties
    private let user : User
    // MARK: Lifecycle
    init(user:User){
        
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Selectors
    
    // MARK: API
    
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
      
        return 10
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath) as! TweetCell
//        cell.delegat = self
        cell.tweet = Tweet.MockData
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
    
    
    
    
    
    
}
