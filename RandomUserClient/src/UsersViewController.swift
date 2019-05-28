//
//  UsersViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = usersTableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? UsersInfoTableViewCell
            else {return UITableViewCell()}

        cell.userNameLabel.text = "Louis Dupont"
        cell.emailLabel.text = "email@web.com"
        return cell
    }


    @IBOutlet weak var usersNavBar: UINavigationBar!
    @IBOutlet weak var usersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click!")
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }

}

