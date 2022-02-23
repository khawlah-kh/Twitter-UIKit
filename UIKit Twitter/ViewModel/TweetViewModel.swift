//
//  TweetViewModel.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 15/02/2022.
//


import UIKit
import Firebase


struct TweetViewModel {
    
    let tweet : Tweet
    let user : User
    
    init(tweet:Tweet){
        self.tweet = tweet
        self.user = tweet.user
    }
    
    var profileImageUrl : URL {
        return tweet.user.profileImageUrl
    }
    
    var userInfoText : NSAttributedString {
        
        let title = NSMutableAttributedString(string: user.fullName, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [.font : UIFont.systemFont(ofSize: 14)
                                                                                   ,.foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " • \(timestampString)", attributes: [.font : UIFont.systemFont(ofSize: 14)
                                                                              ,.foregroundColor: UIColor.lightGray]))
        return title
        
    }
    
    
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: tweet.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp.dateValue())
    }
    
    
    func size (forWidth width : CGFloat)->CGSize{
        let measurmentLabel = UILabel()
        measurmentLabel.text = tweet.caption
        measurmentLabel.numberOfLines = 0
        measurmentLabel.lineBreakMode = .byWordWrapping
        measurmentLabel.translatesAutoresizingMaskIntoConstraints = false
        measurmentLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        let size = measurmentLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
  
    }
    
    
}
