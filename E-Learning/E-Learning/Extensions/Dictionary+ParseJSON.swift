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
        return self[key] as? Bool
    }
    
    func intForKey(_ key: Key) -> Int? {
        return self[key] as? Int
    }
    
    func floatForKey(_ key: Key) -> Float? {
        return self[key] as? Float
    }
    
    func doubleForKey(_ key: Key) -> Double? {
        return self[key] as? Double
    }
    
    func arrayForKey(_ key: Key) -> Array<Any>? {
        return self[key] as? Array<Any>
    }
    
    func dictionaryForKey(_ key: Key) -> Dictionary<AnyHashable, Any>? {
        return self[key] as? Dictionary<AnyHashable, Any>
    }
    
    func toHTTPFormDataDictionary() -> Dictionary {
        var resultDictionary = Dictionary()
        for (key, value) in self {
            if let valueDict = value as? Dictionary {
                makeDict(startKey: key, resultDictionary: &resultDictionary,
                    source: valueDict)
            } else {
                resultDictionary[key] = value
            }
        }
        return resultDictionary
    }
    
    private func makeDict(startKey: Key, resultDictionary: inout Dictionary,
        source: Dictionary) {
        for (key, value) in source {
            let keyString = "\(startKey)[\(key)]"
            if let newKey = keyString as? Key {
                if let valueDict = value as? Dictionary {
                    makeDict(startKey: newKey, resultDictionary: &resultDictionary,
                        source: valueDict)
                } else {
                    resultDictionary[newKey] = value
                }
            }
        }
    }
    
}
