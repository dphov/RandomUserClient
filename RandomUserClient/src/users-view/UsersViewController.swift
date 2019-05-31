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
  let userDetailsSegueId = "ShowUserDetailsSegue"
  let usersTableViewCellId = "UsersInfoTableViewCell"


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
    usersTableView.delegate = self
    usersTableView.dataSource = self
    usersTableView.register(UINib(nibName: usersTableViewCellId, bundle: nil), forCellReuseIdentifier: usersTableViewCellId)
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

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usersTableView.dequeueReusableCell(withIdentifier: usersTableViewCellId, for: indexPath) as? UsersInfoTableViewCell
        else {return UITableViewCell()}
    let rowItem = results[indexPath.row]
    let url = URL(string: (rowItem.picture?.medium!)!)
    var data: Data = Data()

    cell.userNameLabel.text = rowItem.name!.first!.capitalized + " " + rowItem.name!.last!.capitalized
    cell.emailLabel.text = rowItem.email
    DispatchQueue.global().async {
      data = try! Data(contentsOf: url!)
        DispatchQueue.main.async {
          cell.userImageView.image = UIImage(data: data)
      }
    }
    cell.userImageView.layer.masksToBounds = true
    cell.userImageView.layer.cornerRadius = 12.0
    cell.userImageView.layer.borderWidth = 0.5
    cell.userImageView.layer.borderColor = UIColor.gray.cgColor
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
    let indexPath = usersTableView.indexPathForSelectedRow
    let selectedRow = indexPath!.row
    let selectedUser: RandomUserDataModel = results[selectedRow]
    vc.userObject = selectedUser
    DispatchQueue.main.async {
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}


