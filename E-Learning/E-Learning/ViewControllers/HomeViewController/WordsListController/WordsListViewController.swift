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
    private var wordService = WordService()
    fileprivate var words = [Word]()
    fileprivate var categories = [Category]()
    fileprivate let wordsListCellId = "WordsListCellId"
    fileprivate let wordStatus = ["All", "Learned", "Not learn"]
    fileprivate let wordsPerPage = 20
    private var currentPage = 1
    private var currentCategoriesPage = 1
    fileprivate var lastItemReached = false
    fileprivate var hasFilter = false
    fileprivate var categoryId = ""
    fileprivate var wordOption = "all_word"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordsListTableView.register(UINib.init(nibName: "WordsListCell",
            bundle: nil), forCellReuseIdentifier: self.wordsListCellId)
        self.fetchWordsList()
        self.fetchCategories()
        self.loadMoreCategories()
    }
    
    @IBAction func openFilter(_ sender: UIButton) {
        if self.filterViewHeight.constant == 0 {
            self.filterViewHeight.constant = 90
        } else {
            self.filterViewHeight.constant = 0
            if hasFilter {
                self.fetchWordsList()
                self.hasFilter = false
            } else {
                return
            }
        }
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func fetchWordsList() {
        WordService.shared.fetchWordsList(perPage: self.wordsPerPage, option: self.wordOption, categoryId: self.categoryId) { [weak self] (result) in
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
        WordService.shared.fetchWordsList(perPage: self.wordsPerPage, option: self.wordOption, categoryId: self.categoryId) { [weak self] (result) in 
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
    
    func fetchCategories() {
        LessonService.shared.fetchCategories(page: self.currentCategoriesPage, 
            perPage: 10, update: false) { [weak self] (result) in
            switch result {
            case let .success(categories):
                self?.categories = categories
            case let .failure(error):
                self?.categories.removeAll()
                print("Error fetching categories: \(error)")
            }
        }
    }
    
    func loadMoreCategories() {
        LessonService.shared.fetchCategories(page: (self.currentCategoriesPage + 1),
            perPage: 10, update: false) { [weak self] (result) in 
            switch result {
            case let .success(categories):
                let lastIndex = self?.words.count ?? 0
                self?.categories.append(contentsOf: categories)
                self?.currentCategoriesPage += 1
                var newIndexPaths = [IndexPath]()
                if let countCategory = self?.categories.count {
                    for index in 0..<countCategory {
                        newIndexPaths.append(IndexPath(row: index + lastIndex, section: 0))
                    }
                }
            case .failure:
                    print("No more categories to load")
            }
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.wordsListCellId,
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
        if !lastItemReached && (indexPath.row == self.words.count - 1)
            && (self.words.count >= self.wordsPerPage) {
            self.lastItemReached = true
            self.loadMoreWordsList()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        if indexPath.row == self.words.count - 1 {
            self.lastItemReached = false
        }
    }

}

extension WordsListViewController: UIPickerViewDataSource, UIPickerViewDelegate,
    UIPickerViewAccessibilityDelegate {
    
    // MARK: - Picker view datasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.categories.count + 1
        } else if component == 1 {
            return self.wordStatus.count
        }
        return 0
    }
    
    // MARK: Picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
        inComponent component: Int) {
        self.hasFilter = true
        if component == 0 {
            if row != 0 {
                guard let categoryId = categories[row - 1].id else {
                    return
                }
                self.categoryId = "\(categoryId)"
            } else {
                self.categoryId = ""
            }
        }
        if component == 1 {
            if row == 0 {
                self.wordOption = "all_word"
            } else if row == 1 {
                self.wordOption = "learned"
            } else if row == 2 {
                self.wordOption = "no_learn"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerViewLabel = UILabel()
        var categoriesName = ["All"]
            for i in 0..<categories.count {
                categoriesName.append(categories[i].name ?? "")
            }
        if component == 0 {
            pickerViewLabel.text = categoriesName[row]
        }
        if component == 1 {
            pickerViewLabel.text = self.wordStatus[row]
        }
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.adjustsFontSizeToFitWidth = true
        return pickerViewLabel
    }
    
}
