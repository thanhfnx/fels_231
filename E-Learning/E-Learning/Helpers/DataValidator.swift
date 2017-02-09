//
//  DataValidator.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class DataValidator {
    
    class func validate(email: String?) -> (isValid: Bool, result: String) {
        guard let email = email else {
            return (false, kEmptyEmailMessage);
        }
        if email.isEmpty {
            return (false, kEmptyEmailMessage);
        }
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", kEmailRegex)
        if !emailPredicate.evaluate(with: email) {
            return (false, kInvalidEmailMessage)
        }
        return (true, email)
    }
    
    class func validate(password: String?) -> (isValid: Bool, result: String) {
        guard let password = password else {
            return (false, kEmptyPasswordMessage);
        }
        if password.isEmpty {
            return (false, kEmptyPasswordMessage);
        }
        if password.characters.count < kMinimumPasswordLength {
            return (false, kInvalidPasswordLengthMessage)
        }
        return (true, password);
    }

}
