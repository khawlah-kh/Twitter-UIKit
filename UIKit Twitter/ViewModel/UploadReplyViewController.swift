//
//  UploadReplyViewController.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 22/02/2022.
//

import UIKit

enum UploadTweetConfiguration {
    
    case tweet
    case reply(Tweet)
}
struct UploadReplyViewController{
    
    let config : UploadTweetConfiguration
    
    init(config : UploadTweetConfiguration){
        
        self.config=config
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholder = "What's happening ?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholder = "Tweet yourt reply"
            shouldShowReplyLabel = true
            replyText = NSMutableAttributedString(string: "Replying to ", attributes: [.font : UIFont.systemFont(ofSize: 14) ,.foregroundColor: UIColor.lightGray])
            replyText?.append(NSAttributedString(string:"@\(tweet.user.userName)" , attributes:[.font : UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.systemBlue]))
//
        }
    }
    
    let actionButtonTitle : String
    let placeholder : String
    var shouldShowReplyLabel : Bool
    var replyText : NSMutableAttributedString? = nil
  

    
}
