//
//  DataValidator.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class DataValidator {

    class func validate(string: String?, fieldName: String, minimumLength: Int?,
        format: String?,
        compareWith: (compareString: String, compareFieldName: String)?) ->
        (isValid: Bool, result: String) {
        guard let string = string else {
            return (false, String.init(format: "EmptyFieldMessage".localized,
            fieldName))
        }
        if string.isEmpty {
            return (false, String.init(format: "EmptyFieldMessage".localized,
            fieldName))
        }
        if let min = minimumLength, string.characters.count < min {
            return (false,
            String.init(format: "InvalidLengthFieldMessage".localized,
            fieldName, min))
        }
        if let format = format {
            let predicate = NSPredicate(format: "SELF MATCHES %@", format)
            if !predicate.evaluate(with: string) {
                return (false,
                String.init(format: "InvalidFormatFieldMessage".localized,
                fieldName))
            }
        }
        if let second = compareWith, second.compareString != string {
            return (false, String.init(format: "InvalidMatchFieldMessage".localized,
            fieldName, second.compareFieldName.lowercased()))
        }
        return (true, string)
    }

}
