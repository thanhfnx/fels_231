//
//  Dictionary+ParseJSON.swift
//  E-Learning
//
//  Created by Huy Pham on 2/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func stringForKey(_ key: Key) -> String? {
        return self[key] as? String
    }
    
    func boolForKey(_ key: Key) -> Bool? {
        guard let value = self[key] as? String else {
            return nil
        }
        let lowercaseValue = value.lowercased()
        return Bool(lowercaseValue)
    }
    
    func intForKey(_ key: Key) -> Int? {
        guard let value = self[key] as? String else {
            return nil
        }
        return Int(value)
    }
    
    func floatForKey(_ key: Key) -> Float? {
        guard let value = self[key] as? String else {
            return nil
        }
        return Float(value)
    }
    
    func doubleForKey(_ key: Key) -> Double? {
        guard let value = self[key] as? String else {
            return nil
        }
        return Double(value)
    }
    
    func arrayForKey(_ key: Key) -> Array<Any>? {
        return self[key] as? Array<Any>
    }
    
    func dictionaryForKey(_ key: Key) -> Dictionary<AnyHashable, Any>? {
        return self[key] as? Dictionary<AnyHashable, Any>
    }
    
}
