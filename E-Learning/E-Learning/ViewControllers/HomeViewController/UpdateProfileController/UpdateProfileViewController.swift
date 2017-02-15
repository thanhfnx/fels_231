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
    }
    
    fileprivate func setValues() {
        let user = DataStore.shared.loggedInUser
        self.showAvatar?.imageFrom(urlString: user?.avatar)
        self.fullnameTextField?.text = user?.name
        self.emailTextField?.text = user?.email
        // TODO: Update more field
    }
    
    func resetValues() {
        self.setValues()
        self.newPasswordTextField.text = ""
        self.confirmPasswordTextField.text = ""
    }
    
    func updateFullname() {
        guard let newFullname = self.fullnameTextField.text, !newFullname.isEmpty else {
            self.show(message: "Name is invalid!", title: nil, completion: { [weak self] (action) in
                self?.setValues()
            })
            return
        }
        if newFullname == DataStore.shared.loggedInUser?.name {
            return
        }
//        guard let newPassword = self.newPasswordTextField.text, newPassword.characters.count >= kMinimumPasswordLength else {
//            if !newPassword.isEmpty,  {
//                self.show(message: "New password is invalid", title: nil, completion: nil)
//                return
//            }
//            if let confirmPassword = self.confirmPasswordTextField.text, confirmPassword != newPassword {
//                self.show(message: "Confirm password is invalid", title: nil, completion: nil)
//                return
//            }
//        }
        let user = User()
        guard let loggedUser = DataStore.shared.loggedInUser else {
            return
        }
        user.id = loggedUser.id
        user.name = newFullname
        user.email = loggedUser.email
        user.password = loggedUser.password
        user.avatar = loggedUser.avatar
        user.auth_token = loggedUser.auth_token
        UserService.shared.updateProfile(user: user) { [weak self] (message, user) in
            if let message = message {
                self?.show(message: message, title: nil, completion: nil)
                return
            }
            if let user = user {
                DataStore.shared.loggedInUser = user
                self?.show(message: "Thanh cong", title: nil, completion: nil)
                self?.setValues()
            }
        }
    }
        
//    func updatePassword() {
//        guard let oldPassword = self.oldPasswordTextField.text, oldPassword == DataStore.shared.loggedInUser?.password else {
//            self.show(message: "Current password is wrong!", title: nil, completion: { (action) in
//                self.resetValues()
//            })
//            return
//        }
//        guard let newPassword = self.newPasswordTextField.text, newPassword.characters.count >= kMinimumPasswordLength else {
//            self.show(message: "New password is invalid", title: nil, completion: { (action) in
//                self.resetValues()
//            })
//            return
//        }
//        guard let confirmPassword = self.confirmPasswordTextField.text, confirmPassword == newPassword else {
//            self.show(message: "Confirm password is invalid", title: nil, completion: { (action) in
//                self.resetValues()
//            })
//            return
//        }
//        let user = User()
//        guard let loggedUser = DataStore.shared.loggedInUser else {
//            return
//        }
//        user.id = loggedUser.id
//        user.name = loggedUser.name
//        user.email = loggedUser.email
//        user.password = newPassword
//        user.avatar = loggedUser.avatar
//        user.auth_token = loggedUser.auth_token
//        UserService.shared.updateProfile(user: user) { (message, user) in
//            if let message = message {
//                self.show(message: message, title: nil, completion: nil)
//                return
//            }
//            if let user = user {
//                DataStore.shared.loggedInUser = user
//                self.show(message: "Thanh cong", title: nil, completion: nil)
//                self.setValues()
//            }
//        } 
//    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.resetValues()
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        self.updateFullname()
//        self.updatePassword()
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        print("aaa")
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
