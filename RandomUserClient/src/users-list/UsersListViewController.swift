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

class UsersListViewController: UIViewController, ServiceableByRealm {
  //TODO: Make notification from realm to table view (because of featured button)

  let userDetailsSegueId = "ShowUserDetailsSegue"
  let usersListTableViewCellId = "UsersListTableViewCell"
  var realmService: RealmService?
  let usersInfoController = UsersListInfoController()
  var notificationToken: NotificationToken?

  @IBOutlet weak var usersNavBar: UINavigationBar!
  @IBOutlet weak var usersTableView: UITableView!

  var results: Results<RandomUserDataModel> {
    get {
      return (realmService?.getObjects(RandomUserDataModel.self))!
    }
  }

  func setup() {
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    usersTableView.delegate = self
    usersTableView.dataSource = self
    usersTableView.register(UINib(nibName: usersListTableViewCellId, bundle: nil), forCellReuseIdentifier: usersListTableViewCellId)
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    usersInfoController.fetchUsersData { (data) in
      guard let usersData = data else {return}
      for user in usersData.results! {
        let obj = RandomUserDataModel(value: user)
        self.realmService?.create(obj)
      }
    }
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.usersTableView else { return }

      switch changes {
      case .initial: tableView.reloadData()
      case .update(_, let deletions, let insertions, let updates):
        let fromRow = {(row: Int) in
          return IndexPath(row: row, section: 0)}
        tableView.beginUpdates()
        tableView.deleteRows(at: deletions.map(fromRow), with: .automatic)
        tableView.insertRows(at: insertions.map(fromRow), with: .automatic)
        tableView.reloadRows(at: updates.map(fromRow), with: .none)
        tableView.endUpdates()
      case .error(let error): fatalError("\(error)")
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  override func viewWillDisappear(_ animated: Bool) {
    if let token = notificationToken {
      token.invalidate()
    }
  }
}

extension UsersListViewController: UsersListTableViewCellDelegate {
  // todo: favorites read write problem
  func callMe(_ cell: UsersListTableViewCell) {
    if let indexPath = usersTableView.indexPath(for: cell) {
      let selectedRow = indexPath.row
      var selectedUser: RandomUserDataModel = results[selectedRow]
      if var selectedUserId = selectedUser.id,
        let _selectedUser = realmService?.getSpecificObject(RandomUserDataModel.self, primaryKey: selectedUserId){
        if _selectedUser.isInFavorites == true {
          realmService?.update(_selectedUser, with: ["isInFavorites": false])
          cell.favouritesButton.imageView?.image = UIImage.init(named: "star")
          print("selectedUser.isInFavorites should be false", _selectedUser.isInFavorites)
        } else {
          realmService?.update(_selectedUser, with: ["isInFavorites": true])
          cell.favouritesButton.imageView?.image = UIImage.init(named: "star-filled")
          print("selectedUser.isInFavorites should be true", _selectedUser.isInFavorites)
        }
      }
    }
  }
}

// MARK: - UITableViewDelegate
extension UsersListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let customView = UIView.init()

    customView.backgroundColor = UIColor.clear
    cell.backgroundView = customView
    cell.selectedBackgroundView = customView
    let user: RandomUserDataModel = results[indexPath.row]
    let tableCell: UsersListTableViewCell = cell as! UsersListTableViewCell
    if (user.isInFavorites == true) {
      tableCell.favouritesButton.imageView?.image = UIImage.init(named: "star-filled")
    } else {
      tableCell.favouritesButton.imageView?.image = UIImage.init(named: "star")
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return results.count
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
    if let indexPath = usersTableView.indexPathForSelectedRow {
      let selectedRow = indexPath.row
      let selectedUser: RandomUserDataModel = results[selectedRow]
      if let selectedUserId = selectedUser.id {
        vc.userObjectId = selectedUserId
      }
      vc.realmService = realmService
      DispatchQueue.main.async {
        self.navigationController?.pushViewController(vc, animated: true)
      }
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
}

// MARK: - UITableViewDataSource
extension UsersListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = usersTableView.dequeueReusableCell(withIdentifier: usersListTableViewCellId, for: indexPath) as? UsersListTableViewCell
      else {return UITableViewCell()}
    let rowItem = results[indexPath.row]
    let url = URL(string: (rowItem.picture?.medium!)!)
    var data: Data = Data()

    cell.userNameLabel.text = rowItem.name!.first!.capitalized + " " + rowItem.name!.last!.capitalized
    cell.emailLabel.text = rowItem.email
    cell.delegate = self
    if InternetReachiability.isConnectedToNetwork() {
      DispatchQueue.global().async {
        data = try! Data(contentsOf: url!)
        DispatchQueue.main.async {
          cell.userImageView.image = UIImage(data: data)
        }
      }
    }

    cell.userImageView.layer.masksToBounds = true
    cell.userImageView.layer.cornerRadius = 12.0
    cell.userImageView.layer.borderWidth = 0.5
    cell.userImageView.layer.borderColor = UIColor.gray.cgColor
    return cell
  }
}
