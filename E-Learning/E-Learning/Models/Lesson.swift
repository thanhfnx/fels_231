//
//  Lesson.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class Lesson {

    var id: Int?
    var name: String?
    var words = [Word]()
    
    init(dictionary: Dictionary<String, Any>) {
        id = dictionary.intForKey("id")
        name = dictionary.stringForKey("name")
        if let words = dictionary.arrayForKey("words") as? Array<Dictionary<String, Any>> {
            for wordDictionary in words {
                let word = Word(dictionary: wordDictionary)
                self.words.append(word)
            }
        }
    }
    
}
