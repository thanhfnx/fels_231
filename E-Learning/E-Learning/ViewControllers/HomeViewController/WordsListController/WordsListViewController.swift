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
    fileprivate var words = [Word]()
    private var wordService = WordService()
    var categories = [Category]()
    let wordsListCellId = "WordsListCellId"
    let wordStatuses = ["All", "Learned", "Not Learned"]
    private let perPage = 20
    private var currentPage = 1
    fileprivate var lastItemReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordsListTableView.register(UINib.init(nibName: "WordsListCell",
        bundle: nil), forCellReuseIdentifier: wordsListCellId)
        self.fetchWordsList()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        if self.filterViewHeight.constant == 0 {
            self.filterViewHeight.constant = 90
        } else {
            self.filterViewHeight.constant = 0    
        }
        UIView.animate(withDuration: 0.2) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func fetchWordsList() {
        wordService.fetchWordsList(withInfo: ["page": "1",
            "per_page": "\(perPage)"]) { [weak self] (result) in
            self?.currentPage = 1
            switch result {
            case let .success(words):
                self?.words = words
            case let .failure(error):
                self?.words.removeAll()
                print("Error fetching words: \(error)")
            }
            self?.wordsListTableView.reloadData()
        }
    }
    
    func loadMoreWordsList() {
        wordService.fetchWordsList(withInfo: ["page": "\(currentPage + 1)",
            "per_page": "\(perPage)"]) { [weak self] (result) in 
            switch result {
            case let .success(words):
                let lastIndex = self?.words.count ?? 0
                self?.words.append(contentsOf: words)
                self?.currentPage += 1
                var newIndexPaths = [IndexPath]()
                for index in 0..<words.count {
                    newIndexPaths.append(IndexPath(row: index + lastIndex, section: 0))
                }
                self?.wordsListTableView.beginUpdates()
                self?.wordsListTableView.insertRows(at: newIndexPaths, with: .fade)
                self?.wordsListTableView.endUpdates()
            case .failure:
                print("No more words to load")
            }
            self?.wordsListTableView.refreshControl?.endRefreshing()
        }
    }
    
}

extension WordsListViewController: UITableViewDataSource, UITableViewDelegate {
	
    // MARK: - Table view Datasource
    
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
        cell.wordLabel.text = words[indexPath.row].content
        var answer = self.words[indexPath.row].answers
        for i in 0..<answer.count {
            if answer[i].isCorrect == true {
                cell.contentLabel.text = answer[i].content
            } else {
                continue
            }
        }
        return cell
    }
    
    // MARK: - Table view Delegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        guard let wordsListCell = cell as? WordsListCell else {
            return
        }
        wordsListCell.word = words[indexPath.row]
        if !lastItemReached && (indexPath.row == self.words.count - 1) {
            lastItemReached = true
            loadMoreWordsList()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        if indexPath.row == self.words.count - 1 {
            lastItemReached = false
        }
    }

}

extension WordsListViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Picker view datasource

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
    
    // MARK: Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, 
        forComponent component: Int) -> NSAttributedString? {
        if component == 0 {
            return NSAttributedString(string: categories[row].name!)
        } else if component == 1 {
            return NSAttributedString(string: wordStatuses[row])
        }
        return NSAttributedString(string: "")
    }
    
}
