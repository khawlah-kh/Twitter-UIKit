//
//  CaptionTextView.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 13/02/2022.
//

import UIKit


class CaptionTextView : UITextView{
var placeholderLabel : UILabel = {
    
    let label = UILabel()
    label.font=UIFont.systemFont(ofSize: 16)
    label.textColor = .darkGray
    return label
    
}()
    
    

// MARK: lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .systemBackground
        font = UIFont.systemFont(ofSize: 17)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func handelTextInputChange(){
        placeholderLabel.isHidden = !text.isEmpty
    }
}
