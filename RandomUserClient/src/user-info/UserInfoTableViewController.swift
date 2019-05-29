//
//  UserInfoTableViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
class UserInfoTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "UserInfoTopCell", bundle: nil), forCellReuseIdentifier: "UserInfoTopCell")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        var cell1: UserInfoTopCell

        switch indexPath.section {
        case 0:
            cell1 = tableView.dequeueReusableCell(withIdentifier: "UserInfoTopCell", for: indexPath) as! UserInfoTopCell
            //cell1.userAvatarImageView.image = UIImage(named: "user-group")
            print(cell1)
            cell1.firstNameLabel.text = "Jaques"
            cell1.lastNameLabel.text = "Dupont"
            cell1.dateOfBirthLabel.text = "20.10.1988"
            cell1.genderLabel.text = "Male"
            return cell1
        default:
            cell = UITableViewCell()
            return cell
        }
    }
}
