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
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValues()
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShow(_:)),
            name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillHide(_:)),
            name: .UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setValues() {
        let user = DataStore.shared.loggedInUser
        self.avatarImageView?.imageFrom(urlString: user?.avatar,
            defaultImage: #imageLiteral(resourceName: "logo_main"))
        self.fullNameTextField?.text = user?.name
        self.emailTextField?.text = user?.email
    }
    
    fileprivate func resetValues() {
        self.setValues()
        self.newPasswordTextField?.text = ""
        self.confirmPasswordTextField?.text = ""
    }
    
    func updateProfile() {
        self.view.endEditing(true)
        guard let user = DataStore.shared.loggedInUser else {
            return
        }
        guard let fullName = self.fullNameTextField?.text else {
            return
        }
        guard let newPassword = self.newPasswordTextField?.text else {
            return
        }
        guard let confirmPassword = self.confirmPasswordTextField?.text else {
            return
        }
        if fullName == user.name, newPassword.isEmpty, confirmPassword.isEmpty {
            return
        }
        if fullName.isEmpty {
            self.show(message: String.init(format: "EmptyFieldMessage".localized,
            "FullName".localized), title: nil, completion: { (action) in
                self.fullNameTextField?.becomeFirstResponder()
            })
            return
        }
        if !newPassword.isEmpty && newPassword.characters.count < kMinimumPasswordLength {
            self.show(message: String(format: "InvalidLengthFieldMessage".localized,
            "Password".localized, kMinimumPasswordLength), title: nil,
                completion: { (action) in
                self.newPasswordTextField?.becomeFirstResponder()
            })
            return
        }
        if confirmPassword != newPassword{
            self.show(message: String(format: "InvalidMatchFieldMessage".localized,
            "RetypePassword".localized, "Password".localized), title: nil,
                completion: { (action) in
                self.confirmPasswordTextField.becomeFirstResponder()
            })
            return
        }
        let updatingUser = User()
        updatingUser.id = user.id
        updatingUser.auth_token = user.auth_token
        updatingUser.email = user.email
        updatingUser.name = fullName
        updatingUser.password = newPassword
        updatingUser.avatar = ""
        self.indicatorView?.isHidden = false
        UserService.shared.updateProfile(user: updatingUser) { [weak self] (message, user) in
            self?.indicatorView?.isHidden = true
            if let message = message {
                self?.show(message: message, title: nil, completion: nil)
                return
            }
            if let user = user {
                DataStore.shared.loggedInUser = user
                self?.show(message: "UpdateSuccessMessage".localized, title: nil, completion: nil)
                self?.resetValues()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUserDidUpdateProfileNotification),
                    object: nil)
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
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0.0
        let offset = self.emailTextField.frame.origin.y - navigationBarHeight - 32.0
        self.avatarTopLayoutConstraint?.constant -= offset
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0
        self.avatarTopLayoutConstraint?.constant = 16.0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullNameTextField {
            self.fullNameTextField?.resignFirstResponder()
        } else if textField == self.newPasswordTextField {
            self.confirmPasswordTextField?.becomeFirstResponder()
        } else if textField == self.confirmPasswordTextField {
            self.confirmPasswordTextField?.resignFirstResponder()
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
        self.avatarImageView?.image = image
        self.dismiss(animated: true, completion: nil)
    }

}
