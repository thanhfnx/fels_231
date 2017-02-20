//
//  CategoryCell.swift
//  E-Learning
//
//  Created by Huy Pham on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var exampleWordsLabel: UILabel!
    var category: Category? {
        didSet {
            if let category = category {
                nameLabel.text = category.name
                descriptionLabel.text = "You're learned \(category.learnedWords)"
                exampleWordsLabel.text = ""
                photoImageView.image = #imageLiteral(resourceName: "img_category_placeholder")
            } else {
                nameLabel.text = nil
                descriptionLabel.text = nil
                exampleWordsLabel.text = nil
                photoImageView.image = nil
            }
        }
    }
    
}
