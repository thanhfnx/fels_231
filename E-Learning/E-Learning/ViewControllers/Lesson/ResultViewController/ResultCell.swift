//
//  ResultCell.swift
//  E-Learning
//
//  Created by Huy Pham on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    var word: Word? {
        didSet {
            if let word = word {
                wordLabel.text = word.content
                answerLabel.text = word.rightAnswer?.content
                if word.isAnswerRight {
                    self.checkImageView.image = #imageLiteral(resourceName: "ic_true")
                } else {
                    self.checkImageView.image = #imageLiteral(resourceName: "ic_false")
                }
            }
        }
    }

}
