//
//  EditProfileFooterView.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 10/03/2022.
//

import UIKit

protocol EditProfileFooterViewDelegate : class{
    
    
    func handelLogout()
}


class EditProfileFooterView : UIView{
    
    // MARK: - Properties
    weak var delegate : EditProfileFooterViewDelegate?
    
    private lazy var logoutButton : UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handelLogout), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        
        return button
        
        
        
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoutButton)
        logoutButton.anchor(top:topAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        logoutButton.setDimensions(width: self.frame.width-32, height: 50)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handelLogout(){
        
        delegate?.handelLogout()
        
    }
    
}
