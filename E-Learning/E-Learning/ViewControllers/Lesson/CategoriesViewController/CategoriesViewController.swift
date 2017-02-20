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
    private var lastItemReached = false
    private let loadingContainer = UIView()
    private let loadingView =
        UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kCategoriesNavigationTitle
        loadingContainer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingContainer.layer.cornerRadius = 10
        loadingContainer.addSubview(loadingView)
        loadingContainer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        loadingContainer.isHidden = true
        self.view.addSubview(loadingContainer)
        self.refreshList()
        NotificationCenter.default.addObserver(self,
            selector: #selector(refreshList),
            name: NSNotification.Name(rawValue: kUserDidLearnMoreWord),
            object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingContainer.center = CGPoint(x: self.view.bounds.midX,
            y: self.view.bounds.midY)
        loadingView.center = CGPoint(x: loadingContainer.bounds.midX,
            y: loadingContainer.bounds.midY)
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
    
    override func tableView(_ tableView: UITableView,
        willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let categoryCell = cell as? CategoryCell else {
            return
        }
        categoryCell.category = categories[indexPath.row]
        if !lastItemReached && (indexPath.row == self.categories.count - 1) {
            lastItemReached = true
            loadMoreList()
        }
    }
    
    override func tableView(_ tableView: UITableView,
        didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.categories.count - 1 {
            lastItemReached = false
        }
    }
    
    override func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        if let categoryId = self.categories[indexPath.row].id {
            showLoading()
            LessonService.shared.createLesson(categoryId: categoryId) {
                [weak self] (result) in
                self?.hideLoading()
                switch result {
                case let .success(lesson):
                    self?.performSegue(withIdentifier: "ShowLesson",
                        sender: lesson)
                case let .failure(error):
                    print("Error create lesson: \(error)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: - Event handling
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLesson" {
            guard let lesson = sender as? Lesson,
                let lessonViewController = segue.destination
                    as? LessonViewController else {
                return
            }
            lessonViewController.lesson = lesson
        }
    }

    func doneLesson(lesson: Lesson?) {
        if let resultLesson = lesson, let lessonId = resultLesson.id {
            let resultDict =
                ["lesson": self.createLessonResult(lesson: resultLesson)]
            self.showLoading()
            LessonService.shared.updateLesson(lessonId: lessonId,
                lessonResult: resultDict, completion: { [weak self] (result) in
                self?.hideLoading()
                switch result {
                case .success:
                    if let resultViewController =
                        self?.storyboard?.instantiateViewController(
                            withIdentifier: kResultViewControllerId)
                            as? ResultViewController {
                        resultViewController.lesson = lesson
                        self?.present(resultViewController, animated: true,
                            completion: nil)
                        NotificationCenter.default.post(
                            name: Notification.Name(rawValue: kUserDidLearnMoreWord),
                            object: nil)
                    }
                case let .failure(error):
                    print("Error update lesson: \(error)")
                }
            })
        }
    }
    
    // MARK: - Fetch data handling
    
    func refreshList() {
        showLoading()
        LessonService.shared.fetchCategories(page: 1, perPage: 10, update: true)
            { [weak self] (result) in
            self?.hideLoading()
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
        LessonService.shared.fetchCategories(page: Category.currentPage + 1,
            perPage: Category.perPage, update: false) {
            [weak self] (result) in
            switch result {
            case let .success(categories):
                let lastIndex = self?.categories.count ?? 0
                self?.categories.append(contentsOf: categories)
                var newIndexPaths = [IndexPath]()
                for index in 0..<categories.count {
                    newIndexPaths.append(IndexPath(row: index + lastIndex,
                                                   section: 0))
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
            resultsAttributesDict["\(questionIndex)"] =
                lesson.words[questionIndex].result
        }
        lessonDict["results_attributes"] = resultsAttributesDict
        return lessonDict
    }
    
    // MARK: - Loading View
    
    private func showLoading() {
        loadingContainer.isHidden = false
        loadingView.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func hideLoading() {
        loadingContainer.isHidden = true
        loadingView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}
