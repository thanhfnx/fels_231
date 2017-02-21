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
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    var category: Category? {
        didSet {
            guard let category = category else {
                nameLabel.text = nil
                descriptionLabel.text = nil
                photoImageView.image = nil
                self.hideLoading()
                return
            }
            nameLabel.text = category.name
            descriptionLabel.text =
                String(format: "CategoryDescription".localized,
                       category.learnedWords)
            photoImageView.image = #imageLiteral(resourceName: "img_category_placeholder")
            self.updatePhoto()
        }
    }
    
    private func updatePhoto() {
        guard let category = category else {
            return
        }
        self.showLoading()
        LessonService.shared.fetchImage(for: category) { [weak self] (result) in
            self?.hideLoading()
            switch result {
            case let .success(image):
                self?.photoImageView.image = image
            case let .failure(error):
                self?.photoImageView.image = #imageLiteral(resourceName: "img_category_placeholder")
                print("Error get category image: \(error)")
            }
        }
    }
    
    private func showLoading() {
        loadingContainer.isHidden = false
        loadingView.startAnimating()
    }
    
    private func hideLoading() {
        loadingView.stopAnimating()
        loadingContainer.isHidden = true
    }
    
}
