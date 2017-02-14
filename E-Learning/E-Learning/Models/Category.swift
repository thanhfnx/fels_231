//
//  Category.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class Category {

    var id: Int?
    var name: String?
    var photoURL: String?
    var learnedWords = 0
    static var totalPages = 0
 
    init(dictionary: Dictionary<String, Any>) {
        id = dictionary.intForKey("id")
        name = dictionary.stringForKey("name")
        photoURL = dictionary.stringForKey("photo")
        if let intValue = dictionary.intForKey("learned_words") {
            learnedWords = intValue
        }
    }
}
