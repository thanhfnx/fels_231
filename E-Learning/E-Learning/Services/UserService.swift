//
//  UserService.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class UserService: APIService {
    
    static let shared = UserService()
    
    func register(user: User, complete: @escaping (String?, User?) -> ()) {
        let params = [
            "user[name]": user.name,
            "user[email]": user.email,
            "user[password]": user.password,
            "user[password_confirmation]": user.password
        ]
        sendRequest(url: kRegisterURL, method: .post, params: params,
            success: { (json) in
            guard let userJSON = json["user"] as? [String: Any] else {
                if let message = json["email"] as? String {
                    complete(message + "!", nil)
                } else {
                    complete("UnknownError".localized, nil)
                }
                return
            }
            let result = User(keyedValues: userJSON)
            complete(nil, result)
        }) { (error) in
            complete(error, nil)
        }
    }
    
    func login(user: User, complete: @escaping (String?, User?) -> ()) {
        let params: [String: Any] = [
            "session[email]": user.email,
            "session[password]": user.password,
            "session[remember_me]": false
        ]
        sendRequest(url: kLogInURL, method: .post, params: params,
            success: { (json) in
            guard let userJSON = json["user"] as? [String: Any] else {
                if let message = json["message"] as? String {
                    complete(message + "!", nil)
                } else {
                    complete("UnknownError".localized, nil)
                }
                return
            }
            let result = User(keyedValues: userJSON)
            complete(nil, result)
        }) { (error) in
            complete(error, nil)
        }
    }
    
}
