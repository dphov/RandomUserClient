//
//  UsersViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

struct UsersInfoController {
  func fetchUsersData(completion: @escaping (RandomUsersDataRoot?) -> Void) {
    let baseURL = URL(string:"https://randomuser.me/api")!
    let query: [String: String] = [
      "seed": "qwerty",
      "results": "10",
      "page": "1"
    ]
    let url = baseURL.withQueries(query)!
    let task = URLSession.shared.dataTask(with: url){
      (data, response, error) in
        let jsonDecoder = JSONDecoder()
        if let data = data,
          let usersData = try? jsonDecoder.decode(RandomUsersDataRoot.self, from: data)
        {
          completion(usersData)
        } else {
          print("Either no data was returned, or data was not serialized.")
          completion(nil)
          return
        }
    }
    task.resume()
  }
}

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  let usersInfoController = UsersInfoController()
  @IBOutlet weak var usersNavBar: UINavigationBar!
  @IBOutlet weak var usersTableView: UITableView!
  func setup() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    usersInfoController.fetchUsersData { (RandomUsersDataRoot) in
      print(RandomUsersDataRoot!)
//      self.updateDB(with: RandomUsersDataRoot)
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    usersTableView.dataSource = self
    setup()
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return 7
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usersTableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? UsersInfoTableViewCell
        else {return UITableViewCell()}

    cell.userNameLabel.text = "Louis Dupont"
    cell.emailLabel.text = "email@web.com"
    return cell
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    print("click!")
  }
}

