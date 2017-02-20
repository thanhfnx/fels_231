//
//  CategoriesViewController.swift
//  E-Learning
//
//  Created by Huy Pham on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
        
    private var categories = [Category]()
    private var lessonService = LessonService()
    private var lastItemReached = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kCategoriesNavigationTitle
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList),
                                  for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.refreshControl = refreshControl
        self.refreshList()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            kCategoryCellId, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        guard let categoryCell = cell as? CategoryCell else {
            return
        }
        categoryCell.category = categories[indexPath.row]
        if !lastItemReached && (indexPath.row == self.categories.count - 1) {
            lastItemReached = true
            loadMoreList()
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        if indexPath.row == self.categories.count - 1 {
            lastItemReached = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categoryId = self.categories[indexPath.row].id {
            self.lessonService.createLesson(categoryId: categoryId) {
                [weak self] (result) in
                switch result {
                case let .success(lesson):
                    self?.performSegue(withIdentifier: "ShowLesson", sender: lesson)
                case let .failure(error):
                    print("Error create lesson: \(error)")
                }
            }
        }
    }
    
    // MARK: - Event handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLesson" {
            guard let lesson = sender as? Lesson,
                let lessonViewController = segue.destination as? LessonViewController else {
                return
            }
            lessonViewController.lesson = lesson
        }
    }

    func doneLesson(lesson: Lesson?) {
        if let resultLesson = lesson, let lessonId = resultLesson.id {
            let resultDict = ["lesson": self.createLessonResult(lesson: resultLesson)]
            lessonService.updateLesson(lessonId: lessonId, info: resultDict,
                completion: { [weak self] (result) in
                switch result {
                case .success:
                    if let resultViewController =
                        self?.storyboard?.instantiateViewController(withIdentifier:
                            kResultViewControllerId) as? ResultViewController {
                        resultViewController.lesson = lesson
                        self?.present(resultViewController, animated: true, completion: nil)
                    }
                case let .failure(error):
                    print("Error update lesson: \(error)")
                }
            })
        }
    }
    
    // MARK: - Fetch data handling
    
    func refreshList() {
        lessonService.fetchCategories(withInfo: ["page": 1,
            "per_page": "\(Category.perPage)"]) {
            [weak self] (result) in
            switch result {
            case let .success(categories):
                self?.categories = categories
            case let .failure(error):
                self?.categories.removeAll()
                print("Error fetching categories: \(error)")
            }
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func loadMoreList() {
        lessonService.fetchCategories(withInfo: ["page": "\(Category.currentPage + 1)",
            "per_page": "\(Category.perPage)"]) {
            [weak self] (result) in
            switch result {
            case let .success(categories):
                let lastIndex = self?.categories.count ?? 0
                self?.categories.append(contentsOf: categories)
                var newIndexPaths = [IndexPath]()
                for index in 0..<categories.count {
                    newIndexPaths.append(IndexPath(row: index + lastIndex, section: 0))
                }
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: newIndexPaths, with: .fade)
                self?.tableView.endUpdates()
            case .failure:
                print("No more items to load")
            }
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Private Handle

    private func createLessonResult(lesson: Lesson) -> [String: Any] {
        var lessonDict = [String: Any]()
        var resultsAttributesDict = [String: Any]()
        lessonDict["learned"] = true
        for questionIndex in 0..<lesson.words.count {
            resultsAttributesDict["\(questionIndex)"] = lesson.words[questionIndex].result
        }
        lessonDict["results_attributes"] = resultsAttributesDict
        return lessonDict
    }
    
}
