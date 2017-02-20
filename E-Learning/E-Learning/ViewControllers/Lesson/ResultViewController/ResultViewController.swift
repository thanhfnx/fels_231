//
//  ResultViewController.swift
//  E-Learning
//
//  Created by Huy Pham on 2/9/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    var lesson: Lesson!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = lesson.name
        self.countLabel.text = "\(lesson.numberOfRightAnswer)/\(lesson.words.count)"
    }
    
    // MARK: - Button event handling

    @IBAction func onOKPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return lesson.words.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            kResultCellId, for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        cell.word = lesson.words[indexPath.row]
        return cell
    }
    
}
