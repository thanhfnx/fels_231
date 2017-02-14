//
//  Answer.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class Answer {
    
    var id: Int?
    var content: String?
    var isCorrect = false
    
    init(dictionary: Dictionary<String, Any>) {
        id = dictionary.intForKey("id")
        content = dictionary.stringForKey("content")
        if let value = dictionary.boolForKey("is_correct") {
            isCorrect = value
        }
    }
}
