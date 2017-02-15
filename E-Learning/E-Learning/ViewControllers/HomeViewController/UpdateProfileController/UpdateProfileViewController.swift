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
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var showAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
    }
    
    fileprivate func setValues() {
        let user = DataStore.shared.loggedInUser
        self.showAvatar?.imageFrom(urlString: user?.avatar)
        self.fullnameTextField?.text = user?.name
        self.emailTextField?.text = user?.email
        // TODO: Update more field
    }

    @IBAction func resetButtonTapped(_ sender: Any) {
        setValues()
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        print("aaa")
    }
}
