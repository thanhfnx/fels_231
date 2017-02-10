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

class LoginViewController: UIViewController {

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
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
