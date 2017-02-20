//
//  LessonAnswerCell.swift
//  E-Learning
//
//  Created by Huy Pham on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class LessonAnswerCell: UITableViewCell {

    @IBOutlet weak var answerNameLabel: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.answerNameLabel.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1607843137, blue: 0.3882352941, alpha: 1)
            self.answerNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            self.answerNameLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.answerNameLabel.textColor = #colorLiteral(red: 0.1803921569, green: 0.1607843137, blue: 0.3882352941, alpha: 1)
        }
    }
    
}
