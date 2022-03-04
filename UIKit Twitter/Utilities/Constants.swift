//
//  Constants.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 10/02/2022.
//

import Foundation
import Firebase

// Collections
let COLECTION_USERS = Firestore.firestore().collection("Users")
let COLECTION_TWEETS = Firestore.firestore().collection("Tweets")
let COLECTION_USER_TWEETS = Firestore.firestore().collection("User_Tweets")

let COLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLECTION_TWEET_REPLIES = Firestore.firestore().collection("tweet-replies")

let COLECTION_USER_LIKES = Firestore.firestore().collection("user-likes")
let COLECTION_TWEET_LIKES = Firestore.firestore().collection("tweet-likes")

let COLECTION_NOTIFICATIONS = Firestore.firestore().collection("Notifications")





// Sub-Collections
let userFollowingSubCollection = "user-following"
let userFollowersSubCollection = "user-followers"
let tweetsCollection = "tweets"
let repliesCollection = "tweet-replies"
let userLikesTweetCollection = "user-likes"
let tweetLikesTweetCollection = "tweet-likes"
let userNotificationCollection = "user-notification"



//IDs
let reusableCellId = "tweetId"
let headerId = "ProfileHeaderId"
let filterButtonCellId = "filterButtonCellId"
let userCellId = "userCellId"
let actionSheetCellId = "actionSheetCellId"
let tweetDetailsHeaderId = "TweetDetailsViewHeader"
let notificationCellId = "notificationCellId"
