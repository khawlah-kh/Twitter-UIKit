//
//  MainTabViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit
import SwiftUI
import Firebase

enum ActionButtonCinfiguration {
    case tweet
    case message
}
class MainTabViewController: UITabBarController {
    
    
    
    // MARK: - Properties
    private var buttonConfig : ActionButtonCinfiguration = .tweet{
        didSet{
            switch buttonConfig{
            case .tweet:
                actionButton.setImage(UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), for: .normal)
            case .message:
                actionButton.setImage(UIImage(systemName: "envelope"), for: .normal)
            }
            
        }
    }
    var user : User? {
        
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            feed.user = self.user
        }
    }
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
            fetchUser()
            self.configureViewControllers()
            self.configureUI()
            
            
            
        }
        
    }
    
    // MARK: Selectors (Action Handlers)
    @objc func actionButonTapped(){
        
        switch buttonConfig {
        case .tweet:
            handelTweet()
        case .message:
            handelMessage()
        }
        func handelTweet(){
            guard let user = user else {return}
            let controller =  UploadTweetController(user: user, config: .tweet)
            
            guard let feedNav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = feedNav.viewControllers.first as? FeedController else {return}
            controller.delegat = feed
            let nav = UINavigationController(rootViewController:controller )
            
            present(nav , animated: true, completion: nil)
        }
        
        func handelMessage(){
            
            let controller = ExploreController(config: .message)
            let nav = UINavigationController(rootViewController:controller )
            present(nav , animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Helper Functions
    
    func configureUI(){
        self.delegate = self
        view.addSubview(actionButton)
        
        actionButton.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor, right:view.rightAnchor,  paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    func configureViewControllers(){
        
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(imageName: "house.fill", title: "Home", rootViewController: feed)
        
        let explore = ExploreController(config: .search)
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
        
        
        nav.navigationBar.barTintColor = .white
        return nav
        
        
        
        
    }
    
    func fetchUser(){
        AuthService.shared.fetchUser { user in
            self.user = user
        }
        
        
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



// MARK: - UITabBarControllerDelegate

extension MainTabViewController : UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let index = viewControllers?.firstIndex(of: viewController)
        guard let index = index else {return}
        if index == 3 {self.buttonConfig = .message}
        else {self.buttonConfig = .tweet}
        
        
    }
    
}
