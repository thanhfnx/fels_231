//
//  LoginViewController.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

enum ViewTag: Int {
    case emailTextField = 1
    case passwordTextField = 2
    case fullNameTextField = 3
    case retypePasswordTextField = 4
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlet

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func getUser() -> User? {
        return User(email: self.emailTextField?.text,
            password: self.passwordTextField?.text,
            error: { (message, tag) in
            self.show(message: message, title: nil,
                completion: { (action) in
                self.view.viewWithTag(tag)?.becomeFirstResponder()
            })
        })
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.signIn()
        }
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        self.signIn()
    }
    
    fileprivate func signIn() {
        guard let user = getUser() else {
            return
        }
        UserService.shared.login(user: user) { (message, result) in
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
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: kGoToRegisterSegueIdentifier,
            sender: self)
    }

    @IBAction func signInWithFacebookButtonTapped(_ sender: UIButton) {
        // TODO: Sign in with Facebook
    }
    
    @IBAction func signInWithGoogleButtonTapped(_ sender: UIButton) {
        // TODO: Sign in with Google
    }
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
