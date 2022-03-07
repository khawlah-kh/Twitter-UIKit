//
//  EditProfileController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 07/03/2022.
//

import UIKit

class EditProfileController: UITableViewController {


    var user : User
    private lazy var headerView = EditProfileHeader(user: user)

    // MARK: - Properties
    var label : UILabel = {
        let label = UILabel()
      
        return label
    }()
    // MARK: - Lifecycle
    init(user:User){
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        //configureUI()
       
       
    }

    // MARK: - Selectors
    @objc func handelCancel(){

        dismiss(animated: true, completion: nil)
    }
    @objc func handelSave(){
        dismiss(animated: true, completion: nil)
    }
    // MARK: - API
    // MARK: - Helpers
    
    func configureUI(){
        label.text = user.fullName
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 100, paddingLeft: 100)
        
    }

    func configureNavBar(){
//
        
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .twitterBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
       
        
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handelCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handelSave))
        navigationItem.rightBarButtonItem?.isEnabled = false

    }


    
    func configureTableView(){
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:180)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 70
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCellId)
    }
    
}


extension EditProfileController : EditProfileHeaderDelegate{
    func didTabChangeProfilePhoto() {
        print("Show image picker")
    }
    
    
    
    
}

extension EditProfileController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCellId, for: indexPath) as! EditProfileCell
        let option = EditProfileOption(rawValue: indexPath.row)!
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        return cell
    }
    
}

extension EditProfileController{
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       guard let option = EditProfileOption(rawValue: indexPath.row) else  {return 0}
        return option == .bio ? 100 : 48
    }
    
}
