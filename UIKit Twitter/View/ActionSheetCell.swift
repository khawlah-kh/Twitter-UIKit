//
//  ActionSheetCell.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 26/02/2022.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    
    var option : ActionSheetOption? {
        
        didSet{
            configureUI()
            
            
        }
    }
    
    
    // MARK: - Properties
    private let optionImageView : UIImageView = {
        
        let image = UIImageView()
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private let titleLabel : UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Title label"
        return label
    }()
    
    // MARK: - Lifecycle

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
  func  configureUI(){
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left:leftAnchor,paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
      
        addSubview(titleLabel)
       titleLabel.text = option?.description
       titleLabel.centerY(inView: self)
       titleLabel.anchor( left: optionImageView.rightAnchor ,paddingLeft: 16)
      
        
        
    }
    
    
    
}
