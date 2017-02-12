//
//  LessonViewController.swift
//  E-Learning
//
//  Created by Huy Pham on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var wordNameLabel: UILabel!
    var lesson: Lesson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Button event handling
    
    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
        guard let categoriesViewController =
            self.navigationController?.topViewController
            as? CategoriesViewController else {
            return
        }
        categoriesViewController.doneLesson(lesson: lesson)
    }
    
}

extension LessonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            kLessonAnswerCellId, for: indexPath) as? LessonAnswerCell else {
            return UITableViewCell()
        }
        return cell
    }
    
}
