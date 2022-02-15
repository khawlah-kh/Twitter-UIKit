//
//  ExploreController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit

class ExploreController : UIViewController{
    

    // MARK: - Properties
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
       
    }
    
    // MARK: - Helper Functions
    func configureUI(){
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Explore"
    }
    
}
