//
//  NotificationViewModel.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 04/03/2022.
//

import UIKit

struct NotificationViewModel{
    
    
    // MARK: - Prroperties
    let notification : Notification
    let user : User
    var profileImageUrl : URL {
        return user.profileImageUrl
    }
    
    
    
    var notificationText : NSAttributedString {
        
       return attributedText(userName: userName, notificationText: notificationTypeText)
    }
    
    
    var detailedNotificationTime : NSAttributedString{
        let time = NSMutableAttributedString(string:"\(timestampString)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray])
        
        return time
        
        
        
    }
    
    var followButtonTitle : String{
        notification.user.isFollowed ? "Following" : "Follow"
    }
    var shouldShowFollowButton : Bool {
        
        self.notification.type == .follow
    }
    
    
    var userName : String {
        return user.fullName
    }
    
    
    var notificationTypeText : String {
      
        var text = ""
        switch notification.type {
        case .follow:
            text = "has started following you"
        case .like:
            text = "liked your tweet"
            
        case .reply :
            text = "replied to your tweet"
        case .retweet:
            text = "retweeted your tweet"
        case .mention:
            text = "mentioned you in a tweet "
        case .none:
            text = ""
        }
        

        return text
    }
    
    
    
    //MARK: - Lifecycle
    init(notification:Notification){

        self.notification = notification
        self.user = notification.user
    }
    
    
    // MARK: - Helpers
    func attributedText(userName:String,notificationText:String)->NSAttributedString{
        
        let attributedTitle = NSMutableAttributedString(string: "\(userName)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(notificationText)", attributes: [.font : UIFont.systemFont(ofSize: 14)]))

        return attributedTitle
    }
    
    
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: notification.timestamp.dateValue())
    }
    
}
