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
    init(tweet:Tweet){
        self.tweet = tweet
    }
    
    
    
    var profileImageUrl : URL {
        return tweet.profileImageUrl
    }
    
    
    var fullName:String{
        tweet.fullname
    }
    
    
    var username:String{
        "@\(tweet.username)"
    }
    
    var caption :String{
        tweet.caption
    }
    
    var shouldShowReplyLabel : Bool {
        
        tweet.replyingTo != nil
    }
    
    var replyingToText : String{
        
        if let to = tweet.replyingTo{
            return " →Replying to @\(to)"
        }
        else{
            return ""
            
        }
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
    
    var likeButtonTintColor : UIColor {
        
        return tweet.didLike ? .red : .gray
        
    }
    
    var likeButtonImage : UIImage {
        
        if tweet.didLike{
            return UIImage(systemName: "suit.heart.fill")!
        }
        else{
            return UIImage(systemName: "heart")!
        }
        
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
