//
//  NotificationService.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 03/03/2022.
//

import Foundation
import Firebase


struct NotificationService {
    
    static let shared = NotificationService()
    
    
    func uploadeNotification(type : NotificationType,tweet:Tweet? = nil , userId : String? = nil){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var dictionary : [String:Any] = [Notification.timestamp:Timestamp(date: Date()),
                                         Notification.type:type.rawValue,
                                         NotificationService.uid:uid
        ]
        
        // If there is a tweet, that means it is either like or reply notification
        if let tweet = tweet  {
            
            dictionary[Notification.tweetId] = tweet.tweetId
            let ref =           COLECTION_NOTIFICATIONS.document(tweet.uid).collection(userNotificationCollection)
            
            ref.document().setData(dictionary){_ in }
        }
        // Follow
        else if let userId = userId {
            
            let ref =           COLECTION_NOTIFICATIONS.document(userId).collection(userNotificationCollection)
            ref.document().setData(dictionary){ _ in
                // ...
            }
            
        }
        
    }
    
    
    
    func fetchNotifications(completion:@escaping (([Notification]?,Error?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var notifications = [Notification]()
        
        
        
        COLECTION_NOTIFICATIONS.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else {return}
            if !snapshot.exists{
                completion(notifications, nil)
            }
        }
        
        COLECTION_NOTIFICATIONS.document(uid).collection(userNotificationCollection).addSnapshotListener { snapshot, error in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added
            }) else {return}
            
            changes.forEach { change in
                let notificationData = change.document.data()
                
                guard let uid = notificationData[NotificationService.uid] as? String else {return}
                
                AuthService.shared.fetchtUser(withId: uid) { user in
                    let notification = Notification(user: user,dictionary: notificationData)
                    notifications.append(notification)
                    notifications = notifications.sorted (by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
                    completion(notifications,nil)
                    
                }
                
            }
            
        }
        
    }
    
    static let uid = "uid"
    
    
}
