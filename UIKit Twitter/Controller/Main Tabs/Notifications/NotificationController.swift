//
//  NotificationController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 05/02/2022.
//

import Foundation
import UIKit


class NotificationController : UITableViewController{
    
    // MARK: - Properties
    private var nitifications : [Notification] = []
    {
        didSet{
            self.tableView.reloadData()
        }
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    //MARK: - API
    func fetchNotifications(){
        
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { notifications, error in
            guard let notifications = notifications else {return}
            self.refreshControl?.endRefreshing()
            self.nitifications = notifications
            
            for (index,notification) in notifications.enumerated(){
                
                if notification.type == .follow {
                    UserService.shared.checkIfuserIsFollowed(uid: notification.user.id) { isFollowed  in
                        self.nitifications[index].user.isFollowed = isFollowed
                        print(isFollowed)
                    }
                    
                }
            }
        }
    }
    // MARK: - Helper Functions
    
    func configureUI(){
        
        view.backgroundColor = UIColor.systemBackground
        navigationItem.title = "Notifications"
        tableView.register(NotificationCell.self, forCellReuseIdentifier:notificationCellId )
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
    }
    
    
    //MARK: - Selectors
    
    @objc func handelRefresh(){
        
        fetchNotifications()
        
    }
    
}
extension NotificationController{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nitifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: notificationCellId, for: indexPath) as! NotificationCell
        
        
        cell.notification = nitifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let tweetId = nitifications[indexPath.row].tweetId else {return}
        TweetService.shared.fetchtTweet(withId: tweetId) { tweet in
            let controller = TweetDetailsViewController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
}

// MARK: - NotificationCellDelegate

extension NotificationController : NotificationCellDelegate {
    
    func didTapProfileImage(_ cell: NotificationCell) {
        
        guard let  user = cell.notification?.user else {return}
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func didTapFollow(_ cell: NotificationCell) {
        
        guard let user = cell.notification?.user else {return}
        if user.isFollowed {
            
            UserService.shared.unFollow(uid: user.id) {
                cell.notification?.user.isFollowed = false
            }
        }
        
        else{
            UserService.shared.follow(uid: user.id) {
                cell.notification?.user.isFollowed = true
            }
            
            
        }
        
    }
  
}
