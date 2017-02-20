//
//  UpdateProfileViewController.swift
//  E-Learning
//
//  Created by Nguyen Quoc Tinh on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var showAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValues()
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow(_:)),
            name: .UIKeyboardWillShow, object: nil)
        newPasswordTextField.text = nil
        print(newPasswordTextField.text!)
    }
    
    fileprivate func setValues() {
        let user = DataStore.shared.loggedInUser
        self.showAvatar?.imageFrom(urlString: user?.avatar,
            defaultImage: #imageLiteral(resourceName: "logo_main"))
        self.fullnameTextField?.text = user?.name
        self.emailTextField?.text = user?.email
        // TODO: Update more field
    }
    
    func resetValues() {
        self.setValues()
        self.newPasswordTextField.text = ""
        self.confirmPasswordTextField.text = ""
    }
    
    func updateProfile() {
        let newFullname = self.fullnameTextField.text
        let newPassword = self.newPasswordTextField.text
        let confirmPassword = self.confirmPasswordTextField.text
        let user = User()
        guard let loggedUser = DataStore.shared.loggedInUser else {
            return
        }
        user.id = loggedUser.id
        user.auth_token = loggedUser.auth_token
        if newFullname == DataStore.shared.loggedInUser?.name {
            user.name = newFullname!
        } else if let fullname = newFullname, !fullname.isEmpty {
            user.name = fullname
        } else {
            self.show(message: "Name is invalid!", title: nil, completion: nil)
            return
        }
        if let newPassword = newPassword {
            if newPassword.characters.count < kMinimumPasswordLength {
                self.show(message: "New password must more than \(kMinimumPasswordLength) charaters!",
                    title: nil, completion: nil)
                return
            } else {
                user.password = newPassword
            }
        }
        if let confirmPassword = confirmPassword {
            if confirmPassword != newPassword {
                self.show(message: "Confirm password is invalid", title: nil, completion: nil)
                return
            }
        }        
        user.email = loggedUser.email
        user.password = loggedUser.password
        if let image = self.showAvatar?.image {
            user.avatar = UIImageJPEGRepresentation(image, 0.9)?.base64EncodedString() ?? ""
        }
        user.auth_token = loggedUser.auth_token
        UserService.shared.updateProfile(user: user) { [weak self] (message, user) in
            if let message = message {
                self?.show(message: message, title: nil, completion: nil)
                return
            }
            if let user = user {
                DataStore.shared.loggedInUser = user
                self?.show(message: "Cập nhật thành công!", title: nil, completion: nil)
                self?.resetValues()
            }
        }
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.resetValues()
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        self.updateProfile()
    }
    
    @IBAction func changeAvatarButtonTapped(_ sender: UIButton) {
        self.showImagePickerDialog(message: "ChangeAvatarMessage".localized,
        title: "ChoosePhoto".localized, takeFromCameraHandler: { [weak self] (action) in
            self?.showCamera()
        }) { [weak self] (action) in
            self?.showPhotoLibrary()
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil,
            message: "ConfirmLogOutMessage".localized,
            preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "LogOutActionTitle".localized,
            style: .destructive) { (action) in
            DataStore.shared.loggedInUser = nil
            UserDefaults.standard.removeObject(forKey: kLoggedInUserKey)
            self.redirectToLogin()
        }
        let cancelAction = UIAlertAction(title: "CancelActionTitle".localized,
            style: .cancel, handler: nil)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tapGestureRecognized(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    fileprivate func redirectToLogin() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController()
        UIView.transition(with: window, duration: 0.5,
            options: .transitionCurlUp, animations: {
            window.rootViewController = navigationController
        }, completion: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // TODO: Handle keyboard
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // TODO: Handle keyboard
    }
    
}

extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullnameTextField {
            self.fullnameTextField.resignFirstResponder()
        } else if textField == self.newPasswordTextField {
            self.confirmPasswordTextField.becomeFirstResponder()
        } else if textField == self.confirmPasswordTextField {
            self.confirmPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    func showCamera() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.show(message: "OpenCameraErrorMessage".localized, title: nil,
                completion: nil)
        } else {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func showPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage? else {
            return
        }
        self.showAvatar.image = image
        self.dismiss(animated: true, completion: nil)
    }

}
