//
//  LoginController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 06/02/2022.
//

import UIKit
import SwiftUI
import Firebase

class LoginController : UIViewController{
    
    // MARK: Properties
    private let twitterLogo : UIImageView = {
        let uiimage = UIImage(named: "TwitterLogo")
        let uiImageView = UIImageView(image: uiimage)
        uiImageView.contentMode = .scaleAspectFit
        uiImageView.clipsToBounds = true
        return uiImageView
        
    }()
    
    
    private lazy var emailContainerView : UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities.inputContainerView(image: image!, textField: emailTextField)
      
        return view
        
        
    }()
    
    private lazy var passwordContainerView : UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities.inputContainerView(image: image!, textField: passwordTextField)
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
    
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive=true
        button.addTarget(self, action: #selector(handelLogin), for: .touchUpInside)
        return button
  
    }()
    
    private let donotHaveAnAccountButton : UIButton = {
        let button = Utilities.attributedButton(firstPart: "Don't have an account? ", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handeShowingSignUp), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    
    
    // MARK: Selectores (Handler Actions)
    @objc func handelLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}

        
        AuthService.shared.logUserIn(email: email, password: password){ error in
            if let error = error {
                print("Field to login",error.localizedDescription)
                return
            }


                    // to return MainTabViewController, so we can call the functions
                    guard let window = UIApplication.shared.windows.first(where:{ $0.isKeyWindow})else {return}
                    guard let tab = window.rootViewController as? MainTabViewController
                    else{return}
                    tab.authenticateUserAndConfigureUI()
                   // AuthService.shared.fetchUser()
                    self.dismiss(animated: true, completion: nil)

                
            
                
              
            
            
            
            
        }

    }
    @objc func handeShowingSignUp(){
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)

        
    }
    // MARK: Helpers
    
    func configureUI(){
        //Set Logo
        view.addSubview(twitterLogo)
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        twitterLogo.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        twitterLogo.setDimensions(width: 150, height: 150)
        
        //Set TextFields and Login Button
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: twitterLogo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10,paddingLeft: 32,paddingRight: 32)
        view.addSubview(donotHaveAnAccountButton)
        donotHaveAnAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,paddingBottom: 16)
        donotHaveAnAccountButton.centerX(inView: view)
        
        
    }
    
    
}



// MARK: Preview

struct LoginPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        func makeUIViewController(context: UIViewControllerRepresentableContext<LoginPreview.ContainerView>) -> UIViewController {
            return LoginController()
        }

        func updateUIViewController(_ uiViewController: LoginPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoginPreview.ContainerView>) {

        }
    }
}
