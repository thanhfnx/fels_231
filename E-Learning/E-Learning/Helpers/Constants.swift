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

// MARK: - Constants for DataValidator

let kEmptyEmailMessage = "Email can't be empty!"
let kInvalidEmailMessage = "Email format is invalid!"
let kEmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
let kEmptyPasswordMessage = "Password can't be empty!"
let kMinimumPasswordLength = 6
let kInvalidPasswordLengthMessage = "Password can't be less than "
    + "\(kMinimumPasswordLength) characters!"

// MARK: - Constants for Lesson

let kCategoriesNavigationTitle = "Categories".localized
let kCategoryCellId = "CategoryCell"
let kShowLessonSegueId = "ShowLesson"
let kLessonAnswerCellId = "LessonAnswerCell"
let kResultViewControllerId = "ResultViewController"
let kResultCellId = "ResultCell"
