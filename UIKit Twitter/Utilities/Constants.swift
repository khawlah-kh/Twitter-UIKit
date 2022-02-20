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




let reusableCellId = "tweetId"
let headerId = "ProfileHeaderId"
let filterButtonCellId = "filterButtonCellId"
let tweetsCollection = "tweets"
let userCellId = "userCellId"
