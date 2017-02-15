//
//  Word.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class Word {

    var id: Int?
    var resultId: Int?
    var content: String?
    var answers = [Answer]()
    weak var selectedAnswer: Answer?

    init(dictionary: Dictionary<String, Any>) {
        id = dictionary.intForKey("id")
        resultId = dictionary.intForKey("resultId")
        content = dictionary.stringForKey("content")
        if let answers = dictionary.arrayForKey("answers")
            as? Array<Dictionary<String, Any>> {
            for answerDictionary in answers {
                let answer = Answer(dictionary: answerDictionary)
                self.answers.append(answer)
            }
        }
    }
}
