//
//  HomeCell.swift
//  E-Learning
//
//  Created by Nguyen Quoc Tinh on 2/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var inforLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var activity: Activity? {
        didSet {
            guard let activity = activity else {
                return
            }
            self.dateLabel?.text = DateTimeFormatter.default.string(from: activity.created_at,
                outputFormat: "DateTimeFormat".localized)
            self.inforLabel?.text = activity.content
        }
    }
    
}
