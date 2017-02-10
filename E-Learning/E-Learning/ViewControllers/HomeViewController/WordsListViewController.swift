//
//  WordsListViewController.swift
//  E-Learning
//
//  Created by Nguyen Quoc Tinh on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class WordsListViewController: UIViewController {

}

extension WordsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "",
        for: indexPath)
        return cell
    }
}
