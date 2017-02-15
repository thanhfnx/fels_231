//
//  String+Localization.swift
//  E-Learning
//
//  Created by Huy Pham on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import Foundation

extension String {

    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main,
            value: "", comment: "")
    }
    
}
