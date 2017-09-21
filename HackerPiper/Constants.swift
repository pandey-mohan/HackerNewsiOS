//
//  Constants.swift
//  HackerPiper
//
//  Created by mohan on 9/19/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import Foundation
import Alamofire


let kNoNetworkError = "Network Not Avilable"
let appTitle = "Hacker Piper"
var isNetworkAvilable: Bool = true
let loaderText = "Please Wait...."
var reachabilityManager: NetworkReachabilityManager?
let navigationHeight:CGFloat = 150
let tabBarHeight:CGFloat = 50
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let threshholdScrollerValue : CGFloat = 400

//MARK:- API URLs

let topStoryURL = "https://hacker-news.firebaseio.com/v0/topstories.json"
let itemDetail = "https://hacker-news.firebaseio.com/v0/item/"
