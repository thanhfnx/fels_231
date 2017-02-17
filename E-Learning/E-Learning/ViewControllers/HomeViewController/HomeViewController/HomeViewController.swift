//
//  HomeViewController.swift
//  E-Learning
//
//  Created by Tinh on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func setValues() {
        guard let user = DataStore.shared.loggedInUser else {
            return
        }
        self.avatarImageView?.imageFrom(urlString: user.avatar,
            defaultImage: #imageLiteral(resourceName: "logo_main"))
        self.fullNameLabel?.text = user.name
        self.emailLabel?.text = user.email
        self.summaryLabel?.text = String(format: "LearnedWords".localized,
            user.learned_words)
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellId",
            for: indexPath) as? HomeCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
