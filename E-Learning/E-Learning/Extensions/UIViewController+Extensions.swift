//
//  UIViewController+Extensions.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func show(message: String?, title: String?,
        completion: ((UIAlertAction) -> Void)?) {
        guard let message = message else {
            return;
        }
        let alertController = UIAlertController(title: title ?? "Alert",
            message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel,
            handler: completion)
        alertController.addAction(okAction)
        if self.presentedViewController != nil {
            self.dismiss(animated: false, completion: {
                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
