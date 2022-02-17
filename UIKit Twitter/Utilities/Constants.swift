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

let reusableCellId = "tweetId"
let headerId = "ProfileHeaderId"
let filterButtonCellId = "filterButtonCellId"
