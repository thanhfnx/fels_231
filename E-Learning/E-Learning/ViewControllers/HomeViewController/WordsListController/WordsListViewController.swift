//
//  WordsListViewController.swift
//  E-Learning
//
//  Created by Nguyen Quoc Tinh on 2/10/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class WordsListViewController: UIViewController {
    @IBOutlet weak var filterRect: UIView!
    @IBOutlet weak var wordsListTableView: UITableView!
    
    let wordsListCellId = "WordsListCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsListTableView.register(UINib.init(nibName: "WordsListCell",
        bundle: nil), forCellReuseIdentifier: wordsListCellId)
    }
    
    @IBAction func statusFilter(_ sender: Any) {
    }
    @IBAction func categoriesFilter(_ sender: Any) {
    }
}

extension WordsListViewController: UITableViewDataSource, UITableViewDelegate {
	
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: wordsListCellId,
            for: indexPath) as? WordsListCell else {
            return UITableViewCell()
        }
        return cell
    }
}
