//
//  DateTimeFormatter.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/20/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

class DateTimeFormatter: DateFormatter {
    
    static let `default`: DateTimeFormatter = {
        let formatter = DateTimeFormatter()
        formatter.dateFormat = kDefaultInputDateFormat
        return formatter
    }()
    
    func string(from string: String, outputFormat format: String) -> String? {
        guard let date = self.date(from: string) else {
            return nil
        }
        self.dateFormat = format
        let output = self.string(from: date)
        self.dateFormat = kDefaultInputDateFormat
        return output
    }
    
}
