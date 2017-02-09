//
//  User.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class User {

    var id: Int?
    var name: String?
    var email: String?
    var password: String?
    var avatarURL: String?
    var authToken: String?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}
