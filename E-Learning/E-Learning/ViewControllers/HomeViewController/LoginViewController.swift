//
//  LoginViewController.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func getUser() -> User? {
        let email = DataValidator.validate(email: self.emailTextField?.text)
        if !email.isValid {
            self.show(message: email.result, title: nil,
                completion: { (action) in
                self.emailTextField.becomeFirstResponder()
            })
            return nil
        }
        let password = DataValidator.validate(password:
            self.passwordTextField?.text)
        if !password.isValid {
            self.show(message: password.result, title: nil,
                completion: { (action) in
                self.passwordTextField.becomeFirstResponder()
            })
            return nil
        }
        return User(email: email.result, password: password.result)
    }
    
    // MARK: - IBAction
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if let user = getUser() {
            // TODO: Handle login
            print(user)
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

}
