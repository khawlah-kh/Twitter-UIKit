//
//  ExploreController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import UIKit

class ExploreController : UITableViewController{
    

    // MARK: - Properties
    
    var users : [User] = []{
        
        didSet{
            tableView.reloadData()
        }
    }
    var filteredUsers : [User] = []{
        
        didSet{
            tableView.reloadData()
        }
    }
    
    var inSearchMode : Bool{
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private var searchController =  UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
        configureSearchContrpller()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.barStyle = .default
    }
    
    
    // MARK: - Helper Functions
    func configureUI(){
        
        view.backgroundColor = UIColor.systemBackground
        tableView.register(UserCell.self, forCellReuseIdentifier:userCellId )
        tableView.rowHeight = 48 + 8 + 8
        //tableView.separatorStyle = .none
        navigationItem.title = "Explore"
    }
    
    
    func configureSearchContrpller(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    func fetchUser(){
        
        
        UserService.shared.fetchUsers{ users in
            
            self.users = users
            
            
        }
    }
    
    
    
}

//MARK: TableViewDelegate / DataSource
extension ExploreController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as! UserCell
        
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        return cell
    }
    
    
    
    //Handel Cell Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}


// MARK: UISearchResultsUpdating

extension ExploreController:UISearchResultsUpdating{
    //this function get called every single time user types or delete in the search bar
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else {return}
          filteredUsers =  self.users.filter({ user in
            user.fullName.lowercased().contains(query) ||   user.userName.lowercased().contains(query)
       }
                             
       
)
      
        tableView.reloadData()
        
        
    
        
    }
 
    
}
