//
//  LessonViewController.swift
//  E-Learning
//
//  Created by Huy Pham on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    @IBOutlet weak var rightSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var leftSwipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var wordNameLabel: UILabel!
    @IBOutlet weak var goPreviousButton: UIButton!
    @IBOutlet weak var goNextButton: UIButton!
    var lesson: Lesson!
    fileprivate var currentQuestion = 0 {
        didSet {
            updateQuestion(number: currentQuestion)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = lesson.name
        currentQuestion = 0
        rightSwipeGestureRecognizer.addTarget(self, action: #selector(onPreviousPressed))
        leftSwipeGestureRecognizer.addTarget(self, action: #selector(onNextPressed))
    }
    
    // MARK: - Button event handling
    
    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        let _ = navigationController?.popViewController(animated: true)
        guard let categoriesViewController = navigationController?.topViewController
            as? CategoriesViewController else {
            return
        }
        categoriesViewController.doneLesson(lesson: lesson)
    }
    
    @IBAction func onPreviousPressed(_ sender: Any) {
        if let _ = checkExistQuestion(number: currentQuestion - 1) {
            currentQuestion -= 1
        }
    }
    
    @IBAction func onNextPressed(_ sender: Any) {
        if let _ = checkExistQuestion(number: currentQuestion + 1) {
            currentQuestion += 1
        }
    }
    
    // MARK: - Fetch data handling
    
    private func updateQuestion(number: Int) {
        if let word = checkExistQuestion(number: number) {
            countLabel.text = "\(number + 1)/\(lesson.words.count)"
            wordNameLabel.text = word.content
            if number == 0 {
                goPreviousButton.isHidden = true
            } else {
                goPreviousButton.isHidden = false
            }
            if number == lesson.words.count - 1 {
                goNextButton.isHidden = true
            } else {
                goNextButton.isHidden = false
            }
            answersTableView.reloadSections(IndexSet(integer: 0), with: .fade)
            if let selectedAnswer = word.selectedAnswer,
                let answerIndex = word.answers.index(of: selectedAnswer) {
                answersTableView.selectRow(at: IndexPath(row: answerIndex, section: 0),
                    animated: true, scrollPosition: .none)
            }
        } else {
            countLabel.text = "0/0"
            wordNameLabel.text = nil
            goPreviousButton.isHidden = true
            goNextButton.isHidden = true
            answersTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    fileprivate func checkExistQuestion(number: Int) -> Word? {
        if number >= 0 && lesson.words.count > number {
            return lesson.words[number]
        } else {
            return nil
        }
    }
    
}

extension LessonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        if let word = checkExistQuestion(number: currentQuestion) {
            return word.answers.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:
            kLessonAnswerCellId, for: indexPath) as? LessonAnswerCell else {
            return UITableViewCell()
        }
        if let word = checkExistQuestion(number: currentQuestion) {
            cell.answerNameLabel.text = word.answers[indexPath.row].content
        }
        return cell
    }
    
}

extension LessonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRow(at: indexPath, animated: true)
            if let word = checkExistQuestion(number: currentQuestion) {
                word.selectedAnswer = nil
            }
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let word = checkExistQuestion(number: currentQuestion) {
            word.selectedAnswer = word.answers[indexPath.row]
        }
    }
    
}
