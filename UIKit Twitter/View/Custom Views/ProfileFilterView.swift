//
//  ProfileFilterView.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 16/02/2022.
//

import UIKit
protocol ProfileFilterViewDelegate : class {
    
    func handelFilterSelection (_ view : ProfileFilterView , didSelect index : Int)
}


class ProfileFilterView :UIView {
    
    // MARK: Properties
    
    weak var delegate : ProfileFilterViewDelegate?
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    var underlineView : UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
        
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
    
    override func layoutSubviews() {
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
    }
    
    // MARK: Selectors
    // MARK: Helpers
    
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



extension ProfileFilterView {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {return}
        
        
        let xPosision = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosision
        }
        
        
        delegate?.handelFilterSelection(self, didSelect: indexPath.row)
    }
    
    
    
}
