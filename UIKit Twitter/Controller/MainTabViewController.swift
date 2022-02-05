//
//  MainTabViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit
import SwiftUI

class MainTabViewController: UITabBarController {

    
    
    // MARK: - Properties
    // MARK: = Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
       
    }
    
   // MARK: - Helper Functions
    
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
