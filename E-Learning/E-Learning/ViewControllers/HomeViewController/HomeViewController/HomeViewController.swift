//
//  HomeViewController.swift
//  E-Learning
//
//  Created by Tinh on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var userAvatarImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!
    @IBOutlet var wordLearnedLabel: UILabel!
    @IBOutlet var historyTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setValues()
    }
    
    fileprivate func setValues() {
        let user = DataStore.shared.loggedInUser
        self.userAvatarImage?.imageFrom(urlString: user?.avatar)
        self.userNameLabel?.text = user?.name
        self.userEmailLabel?.text = user?.email
        // TODO: Update more field
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
}
