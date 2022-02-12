//
//  RegistrationController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 06/02/2022.
//

import UIKit
import SwiftUI
import Firebase

class RegistrationController : UIViewController{
    
    // MARK: Properties
    private var profileImage:UIImage?
    private let imagePicker : UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        return imagePicker
    }()
    
    private let addAvatarImageButton : UIButton = {
        let image = UIImage(named: "Plus_Photo")
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handelAddProfilePhoto), for: .touchUpInside)
        
        return button
        
        
        
    }()
    
    
    private lazy var emailContainerView : UIView = {
        let view = Utilities.inputContainerView(image: UIImage(systemName: "envelope")!, textField:emailTextField )
        return view
        
    }()
    private lazy var passwordContainerView : UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities.inputContainerView(image: image!, textField: passwordTextField)
        return view
        
        
    }()
    
    private lazy var fullNameContainerView : UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities.inputContainerView(image: image!, textField: fullNameTextField)
        return view
        
        
    }()
    private lazy var UserNameContainerView : UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities.inputContainerView(image: image!, textField: UserNameTextField)
        return view
        
        
    }()
    
    private let emailTextField : UITextField = {
        let textField = Utilities.textField(placeholder: "Email")
        return textField
        
    }()
    private let passwordTextField : UITextField = {
        
        let textField = Utilities.textField(placeholder: "Password")
        textField.isSecureTextEntry = true
        return textField
        
        
    }()
    private let fullNameTextField : UITextField = {
        
        let textField = Utilities.textField(placeholder: "Full Name")
        return textField
        
        
    }()
    
    private let UserNameTextField : UITextField = {
        
        let textField = Utilities.textField(placeholder: "User Name")
        return textField
        
        
    }()
    
    
    
    private let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive=true
        button.addTarget(self, action: #selector(handelSignup), for: .touchUpInside)
        return button
        
    }()
    
    private let donotHaveAnAccountButton : UIButton = {
        let button = Utilities.attributedButton(firstPart: "Already have an account?", secondPart: "Login")
        button.addTarget(self, action: #selector(handelShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    // MARK: Selectores (Handler Actions)
    @objc func handelAddProfilePhoto(){
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @objc func handelSignup(){
        guard let email    = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        guard let userName = UserNameTextField.text else {return}
        guard let profileImage = self.profileImage else {
            print("Please select a profile image")
            return}
        
        let credentials = AuthCredentials(email: email, password: password, fullName: fullName, userName: userName, profileImage: profileImage)
        
        AuthService.shared.creatUser(credentials: credentials){ error in
            
            if error != nil {print("handel error")
                return
            }
            else {
                
                    // to return MainTabViewController, so we can call the functions
                    guard let window = UIApplication.shared.windows.first(where:{ $0.isKeyWindow})else {return}
                    guard let tab = window.rootViewController as? MainTabViewController
                    else{return}
                    tab.authenticateUserAndConfigureUI()
                   // AuthService.shared.fetchUser()
                self.dismiss(animated: true, completion: nil)

                
            }
           
        }
        
        
    }
    @objc func handelShowLogin(){
        navigationController?.popViewController(animated: true)
        
        
    }
    // MARK: Helpers
    
    func configureUI(){
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        view.backgroundColor = .twitterBlue
        view.addSubview(addAvatarImageButton)
        
        addAvatarImageButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        addAvatarImageButton.setDimensions(width: 150, height: 150)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,fullNameContainerView,UserNameContainerView,signupButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: addAvatarImageButton.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,  paddingTop: 16,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(donotHaveAnAccountButton)
        donotHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,   paddingBottom: 16)
        donotHaveAnAccountButton.centerX(inView: view)
    }
    
    
}

// MARK: Preview

struct RegistrationPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<RegistrationPreview.ContainerView>) -> UIViewController {
            return RegistrationController()
        }
        
        func updateUIViewController(_ uiViewController: RegistrationPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<RegistrationPreview.ContainerView>) {
            
        }
    }
}

// MARK: UIImagePickerControllerDelegate

extension RegistrationController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        addAvatarImageButton.layer.cornerRadius = 150 / 2
        addAvatarImageButton.layer.masksToBounds = true
        addAvatarImageButton.imageView?.contentMode = .scaleAspectFill
        addAvatarImageButton.imageView?.clipsToBounds = true
        addAvatarImageButton.layer.borderWidth = 2
        addAvatarImageButton.layer.borderColor = UIColor.white.cgColor
        
        addAvatarImageButton.setImage(profileImage.withRenderingMode(.alwaysOriginal)
                                      , for: .normal)
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

