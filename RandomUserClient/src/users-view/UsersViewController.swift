//
//  UsersViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

  @IBOutlet weak var usersNavBar: UINavigationBar!
  @IBOutlet weak var usersTableView: UITableView!

  let usersInfoController = UsersInfoController()
  lazy var realm = try! Realm()
  var results: Results<RandomUserDataModel> {
    get {
      return realm.objects(RandomUserDataModel.self)//.sorted(byKeyPath: "creationTime", ascending: false)
    }
  }

  func setup() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    usersInfoController.fetchUsersData { (data) in
      guard let usersData = data else {return}
      for user in usersData.results! {
        writeRandomUserDataModel(data: user)
      }
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    usersTableView.dataSource = self
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    setup()
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return results.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usersTableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? UsersInfoTableViewCell
        else {return UITableViewCell()}

    let rowItem = results[indexPath.row]
    let url = URL(string: (rowItem.picture?.medium!)!)
    DispatchQueue.global().async {
      let data = try? Data(contentsOf: url!)
      DispatchQueue.main.async {
        cell.userImageView.image = UIImage(data: data!)
      }
    }
    cell.userNameLabel.text = rowItem.name!.first! + " " + rowItem.name!.last!
    cell.emailLabel.text = rowItem.email
    return cell
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    print("click!")
  }
}


