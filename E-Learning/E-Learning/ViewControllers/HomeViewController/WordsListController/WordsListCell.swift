//
//  WordsListCell.swift
//  E-Learning
//
//  Created by Nguyen Quoc Tinh on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class WordsListCell: UITableViewCell {
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    var word: Word? {
        didSet {
            if let word = word {
                wordLabel.text = word.content
            } else {
                wordLabel.text = nil
            }
        }
    }
    
}
