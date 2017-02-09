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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kCategoriesNavigationTitle
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        // return self.categories.count
        // For demo
        return 10
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
