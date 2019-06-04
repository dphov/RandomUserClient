//
//  UsersViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
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
  private let refreshControl = UIRefreshControl()

  var results: Results<RandomUserDataModel>? {
    if let unwrappedRealmService = realmService {
      return unwrappedRealmService.getObjects(RandomUserDataModel.self)
    } else {
      return nil
    }
  }

  func filterForExactID(_ obj: RandomUserDataModel, id: String) -> Bool {
    if obj.id == id {
      return true
    } else {
      return false
    }
  }

  func refreshUsersData(isNeedToUpdate update: Bool = false) {
    usersInfoController.fetchUsersData { (data) in
      guard let usersData = data else {return}
      if let unwrappedUsersDataResults = usersData.results,
        let unwrappedResults = self.results {
        for user in unwrappedUsersDataResults {
          let obj = RandomUserDataModel(value: user)
          if update {
            self.realmService?.create(obj, update: update)
          } else {
            if unwrappedResults.filter({$0.id == obj.id}).isEmpty {
              self.realmService?.create(obj)
            }
          }
        }
      }
    }
  }
  @IBAction func refreshUsersDataAction() {
      refreshUsersData(isNeedToUpdate: true)
      self.refreshControl.endRefreshing()
  }

  func setup() {
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    usersTableView.delegate = self
    usersTableView.dataSource = self
    usersTableView.register(UINib(nibName: usersListTableViewCellId, bundle: nil), forCellReuseIdentifier: usersListTableViewCellId)
    refreshUsersData()
    self.usersTableView.addSubview(self.refreshControl)
    refreshControl.addTarget(self, action: Selector(("refreshUsersDataAction")), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: "Fetching Users Data ...", attributes: nil)

    guard let unwrappedResults = results else {return}
    notificationToken = unwrappedResults.observe { [weak self] (changes: RealmCollectionChange) in
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.usersTableView.reloadData()
  }
  deinit {
    if let token = notificationToken {
      token.invalidate()
    }
  }
}

// MARK: - UsersListTableViewCellDelegate
extension UsersListViewController: UsersListTableViewCellDelegate {
  // todo: favorites read write problem
  func changeInFavoritesStatus(_ cell: UsersListTableViewCell) {
    if let indexPath = usersTableView.indexPath(for: cell),
      let unwrappedResults = results {
      let selectedRow = indexPath.row
      let selectedUser: RandomUserDataModel = unwrappedResults[selectedRow]
      if let selectedUserId = selectedUser.id,
        let unwrappedSelectedUser = realmService?.getSpecificObject(RandomUserDataModel.self, primaryKey: selectedUserId){
        if unwrappedSelectedUser.isInFavorites == "true" {
          realmService?.update(unwrappedSelectedUser, with: ["isInFavorites": "false"])
          cell.favouritesButton.imageView?.image = UIImage.init(named: "star")
        } else {
          realmService?.update(unwrappedSelectedUser, with: ["isInFavorites": "true"])
          cell.favouritesButton.imageView?.image = UIImage.init(named: "star-filled")
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
    if let unwrappedResults = results {
      let user: RandomUserDataModel = unwrappedResults[indexPath.row]
      let tableCell: UsersListTableViewCell = cell as! UsersListTableViewCell
      if (user.isInFavorites == "true") {
        tableCell.favouritesButton.imageView?.image = UIImage.init(named: "star-filled")
      } else {
        tableCell.favouritesButton.imageView?.image = UIImage.init(named: "star")
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let unwrappedResults = results {
      return unwrappedResults.count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
    if let indexPath = usersTableView.indexPathForSelectedRow,
      let unwrappedResults = results {
      let selectedRow = indexPath.row
      let selectedUser: RandomUserDataModel = unwrappedResults[selectedRow]
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
    if let unwrappedResults = results,
      let rowItemPicture = unwrappedResults[indexPath.row].picture,
      let rowItemPictureMedium = rowItemPicture.medium,
      let rowItemName = unwrappedResults[indexPath.row].name,
      let rowItemNameFirst = rowItemName.first,
      let rowItemNameLast = rowItemName.last {
        let url = URL(string: rowItemPictureMedium)
        var data: Data = Data()

        cell.userNameLabel.text = rowItemNameFirst.capitalized + " " + rowItemNameLast.capitalized
        cell.emailLabel.text = unwrappedResults[indexPath.row].email
        cell.delegate = self
        if InternetReachiability.isConnectedToNetwork() {
          DispatchQueue.global().async {
            data = try! Data(contentsOf: url!)
            DispatchQueue.main.async {
              cell.userImageView.image = UIImage(data: data)
            }
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
