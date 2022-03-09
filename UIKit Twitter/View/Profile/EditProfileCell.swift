//
//  EditProfileCell.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 07/03/2022.
//

import UIKit

protocol EditProfileCellDelegate : class{
    func handelUpdateUserInfo(_ cell : EditProfileCell)
    
    
}
class EditProfileCell: UITableViewCell {

 //MARK: - Properties
    weak var delegate : EditProfileCellDelegate?
    var viewModel : EditProfileViewModel? {
        
        didSet{
            configureUI()
        }
    }
    
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
  
    }()
    
    var infoTextField : UITextField = {
        let textField = UITextField()
        textField.text = "placeholder"
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .twitterBlue
        textField.addTarget(self, action: #selector(handelUpdateUserInfo), for: .editingDidEnd)
        return textField
    }()
    
    
    var bioTextField : InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)

        textView.placeholderLabel.text = "Say something . . . "
        return textView
        
        
        
        
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors
    
    
   @objc func handelUpdateUserInfo(){
        
        
       delegate?.handelUpdateUserInfo(self)
        
    }
    
    
    //MARK: - Helpers
    func configureUI(){
        
        guard let viewModel  = viewModel else {
            return
        }
        titleLabel.text = viewModel.cellLabelText
        infoTextField.isHidden = viewModel.shouldHideTextField
        infoTextField.text = viewModel.textFieldText
        
        bioTextField.isHidden = viewModel.shouldHideTextView
        bioTextField.text = viewModel.textFieldText
        bioTextField.placeholderLabel.isHidden = viewModel.shouldHideBioPlaceholder
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
       
        addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 16,paddingRight: 8)
        addSubview(bioTextField)
        bioTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 16,paddingRight: 8)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
    }
}
