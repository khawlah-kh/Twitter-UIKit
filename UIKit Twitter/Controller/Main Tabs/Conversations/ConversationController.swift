//
//  ConversationController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit

class ConversationController : UIViewController{
    
  
    // MARK: - Properties
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Helper Functions
    
    func configureUI(){
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Messages"
    }
    
    
    
}
