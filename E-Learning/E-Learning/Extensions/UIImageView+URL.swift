//
//  UIImageView+URL.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/13/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

extension UIImageView {

    func imageFrom(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url)
            { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
}
