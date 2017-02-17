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
            return
        }
        let alertController = UIAlertController(title: title ?? "Alert".localized,
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
    
    func showImagePickerDialog(message: String, title: String,
        takeFromCameraHandler: @escaping (UIAlertAction) -> (),
        takeFromLibraryHandler: @escaping (UIAlertAction) -> ()) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: .actionSheet)
        let takeFromCameraAction = UIAlertAction(title: "TakeFromCameraActionTitle".localized,
            style: .default, handler: takeFromCameraHandler)
        let takeFromLibraryAction = UIAlertAction(title: "TakeFromLibraryActionTitle".localized,
            style: .default, handler: takeFromLibraryHandler)
        let cancelAction = UIAlertAction(title: "CancelActionTitle".localized,
            style: .cancel, handler: nil)
        alertController.addAction(takeFromCameraAction)
        alertController.addAction(takeFromLibraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
