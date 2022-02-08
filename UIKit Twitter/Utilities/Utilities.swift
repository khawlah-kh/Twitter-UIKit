//
//  Utilities.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 07/02/2022.
//

import UIKit

class Utilities {
    
    
    static func inputContainerView (image : UIImage , textField:UITextField)->UIView{
        
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive=true
        
        let uiImageView = UIImageView(image: image)
        view.heightAnchor.constraint(equalToConstant: 50).isActive=true
        uiImageView.tintColor = .white
        view.addSubview(uiImageView)
        uiImageView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 30, paddingBottom: 8)
        uiImageView.setDimensions(width: 24, height: 24)
        view.addSubview(textField)
        textField.anchor( left: uiImageView.rightAnchor, bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        
        let divider = UIView()
        divider.backgroundColor = .white
        view.addSubview(divider)
        divider.anchor( left: view.leftAnchor, bottom: view.bottomAnchor,right: view.rightAnchor, paddingLeft: 8,height: 0.75)
        
        
                return view
        
        
        
    }
    
    
    static func textField (placeholder:String)->UITextField{
        let textField = UITextField()
        textField.textColor = .white
        textField.font=UIFont.systemFont(ofSize: 16)
        textField.attributedPlaceholder=NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return textField
        
        
        
    }
    
    
    static func attributedButton (firstPart : String , secondPart : String)->UIButton{
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                                        NSAttributedString.Key.foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string:secondPart, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),   NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal )
        button.setTitleColor(.white, for: .normal)
        return button
        
        
    }
    
    
}
