//
//  JSONObject.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/15/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class JSONObject: NSObject {

    override func setValue(_ value: Any?, forKey key: String) {
        let firstUppercasedCharacter = "\(key.characters.first!)".uppercased()
        let string = String(key.characters.dropFirst())
        let uppercasedKey = "\(firstUppercasedCharacter)\(string)"
        let selector = NSSelectorFromString("set\(uppercasedKey):")
        let responds = self.responds(to: selector)
        if !responds {
            return
        }
        super.setValue(value, forKey: key)
    }
    
    convenience init(keyedValues: [String: Any]) {
        self.init()
        super.setValuesForKeys(keyedValues)
    }
    
    override init() {
        super.init()
    }
    
}
