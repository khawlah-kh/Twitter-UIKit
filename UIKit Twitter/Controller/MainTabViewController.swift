//
//  MainTabViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit
import SwiftUI
import Firebase

class MainTabViewController: UITabBarController {

    
    
    // MARK: - Properties
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
        button.addTarget(self, action: #selector(actionButonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: = Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //AuthService.shared.signUserOut()
        view.backgroundColor = .twitterBlue
        authenticateUserAndConfigureUI()
       
       
    }
    
    // MARK: API
    func authenticateUserAndConfigureUI(){
   
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
       
           
        }
        else{
            configureViewControllers()
            configureUI()
            print("🤍",Auth.auth().currentUser?.uid)
            
        }
   
    }

    // MARK: Selectors (Action Handlers)
    @objc func actionButonTapped(){
        
        print("Action Button Tappedr")
        
    }
    
   // MARK: - Helper Functions
    
    func configureUI(){
        view.addSubview(actionButton)

        actionButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, right:view.rightAnchor,  paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    

    
    func configureViewControllers(){

        
        let feed = FeedController()
        let nav1 = templateNavigationController(imageName: "house.fill", title: "Home", rootViewController: feed)

        let explore = ExploreController()
        let nav2 = templateNavigationController(imageName: "magnifyingglass", title: "Explore", rootViewController: explore)

        
        let notifications = NotificationController()
        let nav3 = templateNavigationController(imageName: "bell.fill", title: "Notifications", rootViewController: notifications)
 
        
        let conversations = ConversationController()
        let nav4 = templateNavigationController(imageName: "envelope.fill", title:  "Chat", rootViewController: conversations)

        self.viewControllers = [nav1 , nav2 , nav3 , nav4]
        
        
        
    }
    
    
    func templateNavigationController(imageName : String ,title:String,rootViewController:UIViewController)->UINavigationController{
        
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = UIImage(systemName: imageName)
        nav.tabBarItem.title = title
        nav.navigationBar.barTintColor = .white
       
        //nav.navigationBar.backgroundColor = .white

        nav.navigationBar.barTintColor = .white
        return nav
        
        
        
        
    }
}





// MARK: Preview


struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {

        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return MainTabViewController()
        }

        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {

        }
    }
}
