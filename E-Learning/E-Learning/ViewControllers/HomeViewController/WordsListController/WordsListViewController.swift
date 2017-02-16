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
    @IBOutlet weak var filterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filterPickerView: UIPickerView!
    let wordsListCellId = "WordsListCellId"
    var categories = ["Item1", "Item2", "Item3", "Item4", "Item5"]
    let wordStatuses = ["All", "Learned", "Not Learned"]
    var words = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsListTableView.register(UINib.init(nibName: "WordsListCell",
        bundle: nil), forCellReuseIdentifier: wordsListCellId)
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        if self.filterViewHeight.constant == 0 {
            self.filterViewHeight.constant = 90
        } else {
            self.filterViewHeight.constant = 0    
        }
        UIView.animate(withDuration: 0.2) { 
            self.view.layoutIfNeeded()
        }
    }
}

extension WordsListViewController: UITableViewDataSource, UITableViewDelegate {
	
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return self.words.count
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

extension WordsListViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return categories.count
        } else if component == 1 {
            return wordStatuses.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, 
        forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return NSAttributedString(string: categories[row])
        } else if component == 1 {
            return NSAttributedString(string: wordStatuses[row])
        }
        return NSAttributedString(string: "")
    }
}
