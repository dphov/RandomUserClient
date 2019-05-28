//
//  UserInfoViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBAction func tappedBackToUsersButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        var cell1: UserInfoTopCell
        var cell2: UserInfoMiddleCell

        switch indexPath.section {
        case 0:
            cell1 = tableView.dequeueReusableCell(withIdentifier: "UserInfoTopCell", for: indexPath) as! UserInfoTopCell
            // cell.userAvatarImageView =
            cell1.firstNameLabel.text = "Jaques"
            cell1.lastNameLabel.text = "Dupont"
            cell1.dateOfBirthLabel.text = "20.10.1988"
            cell1.emailLabel.text = "jaques@dupont.com"
            return cell1
        case 1:
            cell2 = tableView.dequeueReusableCell(withIdentifier: "UserInfoMiddleCell", for: indexPath) as! UserInfoMiddleCell
            return cell2
        default:
            cell = UITableViewCell()
            return cell
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
