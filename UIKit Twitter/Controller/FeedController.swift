//
//  FeedViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit
import SDWebImage

class FeedController : UIViewController{
    

    // MARK: - Properties
    var user : User? {
        didSet{
            configureLeftBarButton()
        }
    }
   

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLeftBarButton()
        configureUI()

    }
    
    // MARK: - Helper Functions
    
    func configureUI(){
        
        view.backgroundColor = UIColor.systemBackground
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView

       
      
        
        
    }
    
    
    func configureLeftBarButton(){
        
        guard let user = user else {return}
        let userImgeView = UIImageView()
        userImgeView.setDimensions(width: 32, height: 32)
        userImgeView.layer.cornerRadius = 32 / 2
        userImgeView.layer.masksToBounds = true
        let imageURL = user.profileImageUrl
        userImgeView.sd_setImage(with: imageURL,completed: nil)
 
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userImgeView)

    }
}
