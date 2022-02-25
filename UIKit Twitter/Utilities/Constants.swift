//
//  Constants.swift
//  UIKit Twitter
//
//  Created by khawlah khalid on 10/02/2022.
//

import Foundation
import Firebase
let COLECTION_USERS = Firestore.firestore().collection("Users")
let COLECTION_TWEETS = Firestore.firestore().collection("Tweets")
let COLECTION_USER_TWEETS = Firestore.firestore().collection("User_Tweets")

let COLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLECTION_TWEET_REPLIES = Firestore.firestore().collection("tweet-replies")




let reusableCellId = "tweetId"
let headerId = "ProfileHeaderId"
let filterButtonCellId = "filterButtonCellId"
let tweetsCollection = "tweets"
let repliesCollection = "tweet-replies"
let userCellId = "userCellId"

let userFollowingSubCollection = "user-following"
let userFollowersSubCollection = "user-followers"
let tweetDetailsHeaderId = "TweetDetailsViewHeader"
