//
//  CategoriesViewController.swift
//  E-Learning
//
//  Created by Huy Pham on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController {
        
    var categories = [Category]()
    var lessonService = LessonService()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kCategoriesNavigationTitle
        lessonService.fetchCategories(withInfo: ["page": "0", "per_page": "10"]) {
            (result) in
            switch result {
            case let .success(categories):
                self.categories = categories
            case let .failure(error):
                self.categories.removeAll()
                print("Error fetching categories: \(error)")
            }
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLesson" {
            // Passing Data here
        }
    }

    func doneLesson(lesson: Lesson?) {
        let resultViewController =
            storyboard?.instantiateViewController(withIdentifier:
            kResultViewControllerId)
        present(resultViewController!, animated: true, completion: nil)
    }
    
}
