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
    @IBOutlet weak var indicatorView: UIView!
    
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
            self.register()
        }
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        self.register()
    }
    
    fileprivate func register() {
        guard let user = getUser() else {
            return
        }
        self.view.endEditing(true)
        self.indicatorView?.isHidden = false
        UserService.shared.register(user: user) { [weak self] (message, result) in
            self?.indicatorView?.isHidden = true
            guard let user = result else {
                if let message = message, !message.isEmpty {
                    self?.show(message: message, title: nil, completion: nil)
                }
                return
            }
            DataStore.shared.loggedInUser = user
            self?.redirectToHome()
        }
    }
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func swipeGestureRecognized(_ sender: UISwipeGestureRecognizer) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func redirectToHome() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController()
        UIView.transition(with: window, duration: 0.5,
            options: .transitionCurlDown, animations: {
            window.rootViewController = navigationController
        }, completion: nil)
    }
    
}
