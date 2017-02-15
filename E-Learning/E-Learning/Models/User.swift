//
//  User.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class Activity: NSObject {

    var id: Int = 0
    var content: String = ""
    var create_at: String = ""
    
}

class User: NSObject {

    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var avatar: String = ""
    var admin: Bool = false
    var auth_token: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var learned_words = 0
    var activities = [Activity]()
    
    override init() {
        super.init()
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if (key == "activities") {
            // TODO
        } else {
            super.setValue(value, forKey: key)
        }
    }

    init(keyedValues: [String: Any]) {
        super.init()
        setValuesForKeys(keyedValues)
    }
    
    init?(email: String?, name: String?, avatar: String?) {
        guard let email = email, let name = name, let avatar = avatar else {
            return nil
        }
        self.email = email
        self.name = name
        self.avatar = avatar
    }
    
    init?(email: String?, password: String?,
        error: @escaping (String, Int) -> Void) {
        let validatedEmail = DataValidator.validate(string: email,
            fieldName: "Email", minimumLength: nil, format: kEmailRegex,
            compareWith: nil)
        if !validatedEmail.isValid {
            error(validatedEmail.result, ViewTag.emailTextField.rawValue)
            return nil
        }
        let validatedPassword =
            DataValidator.validate(string: password,
            fieldName: "Password".localized,
            minimumLength: kMinimumPasswordLength, format: nil, compareWith: nil)
        if !validatedPassword.isValid {
            error(validatedPassword.result, ViewTag.passwordTextField.rawValue)
            return nil
        }
        self.email = validatedEmail.result
        self.password = validatedPassword.result
    }
    
    init?(fullName: String?, email: String?, password: String?,
        retypePassword: String?, error: @escaping (String, Int) -> Void) {
        let validatedFullName =
            DataValidator.validate(string: fullName,
            fieldName: "FullName".localized, minimumLength: nil, format: nil,
            compareWith: nil)
        if !validatedFullName.isValid {
            error(validatedFullName.result, ViewTag.fullNameTextField.rawValue)
            return nil
        }
        guard let user = User(email: email, password: password, error: error)
            else {
            return nil
        }
        let validatedRetypePassword =
            DataValidator.validate(string: retypePassword,
            fieldName: "RetypePassword".localized,
            minimumLength: kMinimumPasswordLength, format: nil,
            compareWith: (password!, "Password".localized))
        if !validatedRetypePassword.isValid {
            error(validatedRetypePassword.result,
            ViewTag.retypePasswordTextField.rawValue)
            return nil
        }
        self.name = validatedFullName.result
        self.email = user.email
        self.password = user.password
    }
    
}
