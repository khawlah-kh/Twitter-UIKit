//
//  EditProfileController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 07/03/2022.
//

import UIKit

protocol  EditProfileControllerDelegate : class {
    
    func didFinishUpdateProfile(forUser : User)
    func handelLogout()
}

class EditProfileController: UITableViewController {


    var user : User
    weak var delegate : EditProfileControllerDelegate?
    var userInfoChanged = false
    var userImageChanged = false

    private lazy var headerView = EditProfileHeader(user: user)
    private  var footerView = EditProfileFooterView()

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
    
    private var profileImage:UIImage?{
        didSet{
        headerView.profileImageView.image = profileImage
        }
    }
    private let imagePicker : UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        return imagePicker
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        configureUI()
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.barStyle = .default
    }
    // MARK: - Selectors
    @objc func handelCancel(){

        dismiss(animated: true, completion: nil)
    }
    @objc func handelSave(){
        view.endEditing(true)
        guard userImageChanged || userInfoChanged else {
            handelCancel()
            return}
        
        updateUserData()
      
    }
    
    func updateUserData(){
        
        if userImageChanged && !userInfoChanged{
            if let profileImage = self.profileImage {
            UserService.shared.updateUserImage(image: profileImage) { profileImageURL in
                self.user.profileImageUrl = URL(string: profileImageURL)!
                AuthService.shared.user?.profileImageUrl = URL(string: profileImageURL)!
            self.handelCancel()
            }
        }
            
            
        }
        else if !userImageChanged && userInfoChanged{
            UserService.shared.updateUserData(user: user) {
                self.delegate?.didFinishUpdateProfile(forUser: self.user)
                self.handelCancel()

            }
            
        }
        else if userImageChanged && userInfoChanged{
            UserService.shared.updateUserData(user: user) {
                self.delegate?.didFinishUpdateProfile(forUser: self.user)
                if self.userImageChanged{
                    if let profileImage = self.profileImage {
                        UserService.shared.updateUserImage(image: profileImage) { profileImageURL in
                            self.user.profileImageUrl = URL(string: profileImageURL)!
                            AuthService.shared.user?.profileImageUrl = URL(string: profileImageURL)!
                            self.handelCancel()
                        }
                    }
                }
            }
        }
        
        
        
    }
    // MARK: - API
    // MARK: - Helpers
    
    func configureUI(){

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }

    func configureNavBar(){

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
        //navigationItem.rightBarButtonItem?.isEnabled = userInfoChanged

    }


    
    func configureTableView(){
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:180)
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height:50)

        footerView.delegate = self
        tableView.tableFooterView = footerView
        tableView.rowHeight = 70
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCellId)
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
        cell.delegate = self
        return cell
    }
    
}

extension EditProfileController{
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       guard let option = EditProfileOption(rawValue: indexPath.row) else  {return 0}
        return option == .bio ? 100 : 48
    }
    
}


// MARK: - EditProfileHeaderDelegate

extension EditProfileController : EditProfileHeaderDelegate{
    func didTabChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
}


// MARK: UIImagePickerControllerDelegate

extension EditProfileController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        userImageChanged = true
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

// MARK: - EditProfileCellDelegate

extension EditProfileController : EditProfileCellDelegate{
    func handelUpdateUserInfo(_ cell: EditProfileCell) {
        userInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = userInfoChanged
        
        guard let option = cell.viewModel?.option else {return}
        switch(option){
            
        case .fullName:
          
            guard let updatedFullname = cell.infoTextField.text else {return}
            user.fullName = updatedFullname
        case .userName:
            guard let updateUsername = cell.infoTextField.text else {return}
            user.userName = updateUsername
            
        case .bio:
            user.bio = cell.bioTextField.text
        }

        
    }
    
    
    
}



// MARK: - EditProfileFooterViewDelegate
extension EditProfileController : EditProfileFooterViewDelegate {
    func handelLogout() {
       
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out ?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            
            
            self.dismiss(animated: true) {
                self.delegate?.handelLogout()
            }
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        present(alert, animated: true) {
            
        }

    }
  
    
}
