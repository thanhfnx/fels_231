//
//  RegisterViewController.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func getUser() -> User? {
        return User(fullName: self.fullNameTextField?.text,
            email: self.emailTextField?.text,
            password: self.passwordTextField?.text,
            retypePassword: self.retypePasswordTextField?.text,
            error: { (message, tag) in
            self.show(message: message, title: nil,
                completion: { (action) in
                self.view.viewWithTag(tag)?.becomeFirstResponder()
            })
        })
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullNameTextField {
            self.emailTextField.becomeFirstResponder()
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.retypePasswordTextField.becomeFirstResponder()
        } else if textField == self.retypePasswordTextField {
            self.signUp()
        }
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        self.signUp()
    }
    
    fileprivate func signUp() {
        guard let user = getUser() else {
            return
        }
        UserService.shared.register(user: user) { (message, result) in
            guard let user = result else {
                if let message = message, !message.isEmpty {
                    self.show(message: message, title: nil, completion: nil)
                }
                return
            }
            DataStore.shared.loggedInUser = user
            self.performSegue(withIdentifier: kGoToHomeSegueIdentifier,
                sender: self)
        }
    }
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
