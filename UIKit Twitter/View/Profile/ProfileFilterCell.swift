//
//  ProfileFilterCell.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 16/02/2022.
//

import UIKit



class ProfileFilterCell : UICollectionViewCell {
    
    // MARK: Properties
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
        
    }()
    
    
    var underlineView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
        
    }()
    
    override var isSelected: Bool {
        didSet{
        titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
                     
            
        }
        
    }


    
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()

       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    func configureUI(){
        
        addSubview(titleLabel)
         titleLabel.center(inView: self)
   
        
    }
    
    
    
    
}
