//
//  Constants.swift
//  E-Learning
//
//  Created by Huy Pham on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

// MARK: - Constants for LoginViewController

let kGoToRegisterSegueIdentifier = "goToRegister"
let kGoToHomeSegueIdentifier = "goToHome"

// MARK: - Constants for DataValidator

let kEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let kMinimumPasswordLength = 6
//let kInvalidRetypePasswordMessage = "InvalidRetypePasswordMessage".localized

// MARK: - Constants for Lesson

let kCategoriesNavigationTitle = "Categories".localized
let kCategoryCellId = "CategoryCell"
let kShowLessonSegueId = "ShowLesson"
let kLessonAnswerCellId = "LessonAnswerCell"
let kResultViewControllerId = "ResultViewController"
let kResultCellId = "ResultCell"

// MARK: - Constants for API
let kBaseURL = "https://manh-nt.herokuapp.com/"
let kRegisterURL = "\(kBaseURL)users.json"
let kRegisterWithSocialURL = "\(kBaseURL)auths.json"
let kLogInURL = "\(kBaseURL)login.json"
let kLogOutURL = "\(kBaseURL)logout.json"
let kGetCategoriesURL = "\(kBaseURL)categories.json"
let kCreateLessonURL = "\(kBaseURL)categories/%d/lessons.json"
let kUpdateLessonURL = "\(kBaseURL)lessons/%d.json"
let kGetWordsURL = "\(kBaseURL)words.json"
let kShowUserURL = "\(kBaseURL)users/%d.json"
let kUpdateProfileURL = "\(kBaseURL)users/%d.json"
