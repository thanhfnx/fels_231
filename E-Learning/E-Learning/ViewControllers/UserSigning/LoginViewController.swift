//
//  LoginViewController.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit
import FBSDKLoginKit

enum ViewTag: Int {
    case emailTextField = 1
    case passwordTextField = 2
    case fullNameTextField = 3
    case retypePasswordTextField = 4
}

class LoginViewController: UIViewController, UITextFieldDelegate,
    GIDSignInDelegate, GIDSignInUIDelegate {

    // MARK: - IBOutlet

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicatorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
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
    
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
        withError error: Error!) {
        if error != nil {
            return
        }
        guard
            let id = user.authentication.idToken,
            let name = user.profile.name,
            let email = user.profile.email,
            let avatar = user.profile.imageURL(withDimension: 400)
            else {
            return
        }
        if let user = User(email: email, name: name, avatar: avatar.absoluteString) {
            self.indicatorView?.isHidden = false
            UserService.shared.loginWithSocial(user: user, provider: "google",
                socialId: id, complete: { [weak self] (message, result) in
                self?.indicatorView?.isHidden = true
                guard let user = result else {
                    if let message = message, !message.isEmpty {
                        self?.show(message: message, title: nil, completion: nil)
                    }
                    return
                }
                DataStore.shared.loggedInUser = user
                self?.performSegue(withIdentifier: kGoToHomeSegueIdentifier,
                    sender: self)
            })
        }
    }
    
    // MARK: - GIDUISignInDelegate
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.logIn()
        }
        return true
    }
    
    // MARK: - IBAction
    
    @IBAction func logInButtonTapped(_ sender: UIButton) {
        self.logIn()
    }
    
    fileprivate func logIn() {
        guard let user = getUser() else {
            return
        }
        self.view.endEditing(true)
        self.indicatorView?.isHidden = false
        UserService.shared.login(user: user) { [weak self] (message, result) in
            self?.indicatorView?.isHidden = true
            guard let user = result else {
                if let message = message, !message.isEmpty {
                    self?.show(message: message, title: nil, completion: nil)
                }
                return
            }
            DataStore.shared.loggedInUser = user
            self?.performSegue(withIdentifier: kGoToHomeSegueIdentifier,
                sender: self)
        }
    }
    
    @IBAction func goToRegisterButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: kGoToRegisterSegueIdentifier,
            sender: self)
    }

    @IBAction func logInWithFacebookButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.indicatorView?.isHidden = false
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"],
            from: self) { [weak self] (result, error) in
            if let error = error {
                self?.indicatorView?.isHidden = true
                self?.show(message: error.localizedDescription, title: nil, completion: nil)
                return
            }
            guard let result = result else {
                self?.indicatorView?.isHidden = true
                return
            }
            if (result.isCancelled) {
                self?.indicatorView?.isHidden = true
                return
            }
            let params = ["fields": "id, email, name, picture.type(large)"]
            FBSDKGraphRequest(graphPath: "me", parameters: params).start {
                (connection, result, error) in
                if let error = error {
                    self?.indicatorView?.isHidden = true
                    self?.show(message: error.localizedDescription, title: nil,
                        completion: nil)
                    return
                }
                guard let result = result as? [String: Any] else {
                    return
                }
                guard
                    let id = result["id"] as? String,
                    let email = result["email"] as? String,
                    let name = result["name"] as? String,
                    let picture = result["picture"] as? NSDictionary,
                    let data = picture["data"] as? NSDictionary,
                    let url = data["url"] as? String
                    else {
                    return
                }
                if let user = User(email: email, name: name, avatar: url) {
                    UserService.shared.loginWithSocial(user: user, provider: "facebook",
                        socialId: id, complete: { (message, result) in
                        self?.indicatorView?.isHidden = true
                        guard let user = result else {
                        if let message = message, !message.isEmpty {
                            self?.show(message: message, title: nil, completion: nil)
                        }
                        return
                    }
                    DataStore.shared.loggedInUser = user
                    self?.performSegue(withIdentifier: kGoToHomeSegueIdentifier,
                        sender: self)
                    })
                }
            }
        }
    }
    
    @IBAction func logInWithGoogleButtonTapped(_ sender: GIDSignInButton) {
        self.view.endEditing(true)
        self.indicatorView?.isHidden = false
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
