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
 
    init(dictionary: Dictionary<String, Any>) {
        id = dictionary.intForKey("id")
        name = dictionary.stringForKey("name")
        photoURL = dictionary.stringForKey("photo")
        if let intValue = dictionary.intForKey("learned_words") {
            learnedWords = intValue
        }
    }
    
}

extension Category: Equatable {
    
    public static func ==(lhs: Category, rhs: Category) -> Bool {
        if let lhsId = lhs.id, let rhsId = rhs.id {
            return lhsId == rhsId
        } else {
            return false
        }
    }
    
}

extension Category {
    
    static var totalPages = 0
    static var perPage = 10
    static var currentPage: Int {
        return DataStore.shared.categories.count / perPage
    }
    
}
