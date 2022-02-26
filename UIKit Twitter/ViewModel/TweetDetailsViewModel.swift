//
//  TweetDetailsViewModel.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 21/02/2022.
//

import UIKit


struct TweetDetailsViewModel{
    
    
    
    // MARK: - Prroperties
    let tweet : Tweet
    let user : User
    init(tweet:Tweet){
        
        
        self.tweet = tweet
        self.user = tweet.user
    }
    
    
    
    var profileImageUrl : URL {
        return user.profileImageUrl
    }
    
    
    var fullName:String{
        user.fullName
    }
    
    
    var username:String{
       "@\(user.userName)"
    }
    
    var caption :String{
        tweet.caption
    }
    
    
    var detailedTweetTime : NSAttributedString{
        let time = NSMutableAttributedString(string:"\(timestampString) • \(detailedTimestampString)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray])
        
        return time
        
        
        
    }
    
    var retweetString:NSAttributedString {
        
        
        attributedText(value: tweet.retweet, text: "Retweets")
        
    }
    
    var likesString:NSAttributedString {
        
        
        attributedText(value: tweet.likes, text: "Likes")
        
    }
    
    // MARK: - Helpers
    func attributedText(value:Int,text:String)->NSAttributedString{
        
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.systemFont(ofSize: 14)
                                                                                   ,.foregroundColor : UIColor.lightGray
                                                                                   ]))

        return attributedTitle
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
    

}