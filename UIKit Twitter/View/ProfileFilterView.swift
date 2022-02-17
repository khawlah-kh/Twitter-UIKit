//
//  ProfileFilterView.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 16/02/2022.
//

import UIKit


class ProfileFilterView :UIView {
    
    // MARK: Properties
    
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    // MARK: Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ProfileFilterCell.self,forCellWithReuseIdentifier: filterButtonCellId)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        
        

        let firstCellIndex = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: firstCellIndex, animated: true, scrollPosition: .left)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Selectors
    // MARK: Helpers
    
    func  configureUI(){
        
        
    }
    
    
    
    
    
    
    
    
}

extension ProfileFilterView : UICollectionViewDelegate {
    

    
}
extension ProfileFilterView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileHeaderOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterButtonCellId, for: indexPath) as! ProfileFilterCell

            let option = ProfileHeaderOptions(rawValue: indexPath.row)!
            cell.titleLabel.text = option.description

        return cell
    }
    

}
// MARK: Collection View UICollectionViewDelegateFlowLayout


extension ProfileFilterView:UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width:frame.width / CGFloat(ProfileHeaderOptions.allCases.count) , height: frame.height)
 
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
