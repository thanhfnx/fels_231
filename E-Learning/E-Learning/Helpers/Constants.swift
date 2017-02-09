//
//  Constants.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/9/17.
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
