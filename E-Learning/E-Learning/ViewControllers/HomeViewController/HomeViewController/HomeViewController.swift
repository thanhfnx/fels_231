//
//  HomeViewController.swift
//  E-Learning
//
//  Created by Tinh on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    enum TableViewType: Int {
        case summary = 0
        case activityLog = 1
    }

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var historyTableView: UITableView!
    
    var learnedActivities = [Activity]()
    var loggingActivities = [Activity]()
    var activities = [Activity]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = DataStore.shared.loggedInUser else {
            return
        }
        self.learnedActivities = user.activities.filter({
            $0.content.hasPrefix("Learned ")
        })
        self.loggingActivities = user.activities.filter({
            !$0.content.hasPrefix("Learned ")
        })
        self.activities = self.learnedActivities
    }
    
    fileprivate func setValues() {
        guard let user = DataStore.shared.loggedInUser else {
            return
        }
        self.avatarImageView?.imageFrom(urlString: user.avatar,
            defaultImage: #imageLiteral(resourceName: "logo_main"))
        self.fullNameLabel?.text = user.name
        self.emailLabel?.text = user.email
        self.summaryLabel?.text = String(format: "LearnedWords".localized,
            user.learned_words)
    }
    
    // MARK: - IBAction
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        guard let user = DataStore.shared.loggedInUser else {
            return
        }
        UserService.shared.refresh(user: user) { [weak self] (message, result) in
            guard let user = result else {
                if let message = message, !message.isEmpty {
                    self?.show(message: message, title: nil, completion: nil)
                }
                return
            }
            DataStore.shared.loggedInUser = user
            self?.setValues()
        }
    }
    
    @IBAction func tableTypeValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case TableViewType.summary.rawValue:
            self.activities = self.learnedActivities
        case TableViewType.activityLog.rawValue:
            self.activities = self.loggingActivities
        default:
            break
        }
        self.historyTableView.reloadData()
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return self.activities.count == 0 ? 1 : self.activities.count
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.activities.count != 0 else {
            let newCell = UITableViewCell()
            newCell.textLabel?.font = UIFont.systemFont(ofSize: 14.0,
                weight: UIFontWeightLight)
            newCell.textLabel?.textAlignment = .center
            newCell.textLabel?.text = "NoData".localized
            return newCell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kHistoryCellIdentifier,
            for: indexPath) as? HomeCell else {
            return UITableViewCell()
        }
        cell.activity = self.activities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.activities.count == 0 ? tableView.frame.size.height : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView,
        heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
