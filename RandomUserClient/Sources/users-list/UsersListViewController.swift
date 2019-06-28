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
  let userDetailsSegueId = "ShowUserDetailsSegue"
  let usersListTableViewCellId = "UsersListTableViewCell"
  var realmService: RealmService?
  var usersInfoController = UsersListInfoController()
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

  func getNextPageIndex(elemPerPage: Int) -> Int {
    guard let resCount = results?.count else {return 0}
    var currentPage: Int

    if resCount == 0 {
      return 1
    }
    currentPage = resCount / elemPerPage
    if resCount <= usersInfoController.lastPage {
      return currentPage + 1
    }
    return 0
  }

  func addUsersData(isNeedToUpdate update: Bool = false) {
    usersInfoController.fetchingMore = true
    var page: Int {
      if update {
        return 1
      } else {
        return getNextPageIndex(elemPerPage: 10)
      }
    }
    usersInfoController.fetchUsersData(forPage: page) { (data) in
      guard let usersData = data else {return}
      if update {
        self.realmService?.deleteAll()
      }
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
        self.usersInfoController.fetchingMore = false
      }
    }
  }

  @IBAction func refreshUsersDataAction() {
      addUsersData(isNeedToUpdate: true)
      self.refreshControl.endRefreshing()
  }

  func setup() {
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    usersTableView.delegate = self
    usersTableView.dataSource = self
    usersTableView.register(UINib(nibName: usersListTableViewCellId, bundle: nil), forCellReuseIdentifier: usersListTableViewCellId)
    usersTableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    addUsersData()
    self.usersTableView.addSubview(self.refreshControl)
    refreshControl.addTarget(self, action: #selector(UsersListViewController.refreshUsersDataAction), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: "Pull down for wipeing table...", attributes: nil)

    guard let unwrappedResults = results else {return}
    notificationToken = unwrappedResults.observe { [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.usersTableView else { return }
      switch changes {
      case .initial:
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let updates):
        let fromRow = { (row: Int) in
          return IndexPath(row: row, section: 0)
        }
        tableView.beginUpdates()
        tableView.deleteRows(at: deletions.map(fromRow), with: .automatic)
        tableView.insertRows(at: insertions.map(fromRow), with: .automatic)
        tableView.reloadRows(at: updates.map(fromRow), with: .none)
        tableView.endUpdates()
      case .error(let error):
        fatalError("\(error)")
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
  func changeInFavoritesStatus(_ cell: UsersListTableViewCell) {
    if let indexPath = usersTableView.indexPath(for: cell),
      let unwrappedResults = results {
      let selectedRow = indexPath.row
      let selectedUser: RandomUserDataModel = unwrappedResults[selectedRow]
      if let selectedUserId = selectedUser.id,
        let unwrappedSelectedUser = realmService?.getSpecificObject(RandomUserDataModel.self, primaryKey: selectedUserId) {
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
        if type(of: cell) == UsersListTableViewCell.self {
          if let tableCell = cell as? UsersListTableViewCell {
            if user.isInFavorites == "true" {
              tableCell.favouritesButton.imageView?.image = UIImage.init(named: "star-filled")
            } else {
              tableCell.favouritesButton.imageView?.image = UIImage.init(named: "star")
            }
          }
        }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if let unwrappedResults = results {
        return unwrappedResults.count < 1 ? 0 : unwrappedResults.count
      }
    } else if section == 1 && usersInfoController.fetchingMore {
      return 1
    }
    return 0
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    // TODO: fix update of sections
    return 1
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as? UserInfoViewController,
        let indexPath = usersTableView.indexPathForSelectedRow,
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

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if offsetY > contentHeight - scrollView.frame.height * 4 {
      if !usersInfoController.fetchingMore {
        addUsersData()
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension UsersListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      guard let cell = usersTableView.dequeueReusableCell(withIdentifier: usersListTableViewCellId, for: indexPath) as? UsersListTableViewCell
      else { return UITableViewCell() }
      if let unwrappedResults = results,
        let rowItemPicture = unwrappedResults[indexPath.row].picture,
        let rowItemPictureMedium = rowItemPicture.medium,
        let rowItemName = unwrappedResults[indexPath.row].name,
        let rowItemNameFirst = rowItemName.first,
        let rowItemNameLast = rowItemName.last {
          guard let url = URL(string: rowItemPictureMedium) else { return UITableViewCell() }
          var data: Data = Data()

          cell.userNameLabel.text = rowItemNameFirst.capitalized + " " + rowItemNameLast.capitalized
          cell.emailLabel.text = unwrappedResults[indexPath.row].email
          cell.delegate = self
          if InternetReachiability.isConnectedToNetwork() {
            DispatchQueue.global().async {
              do {
                data = try Data(contentsOf: url)
              } catch {
                print(error.localizedDescription)
              }
                DispatchQueue.main.async {
                cell.userImageView.image = UIImage(data: data)
              }
            }
          }
      }
      return cell
    } else {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? LoadingCell {
        cell.spinner.startAnimating()
        return cell
      } else { return UITableViewCell() }
    }
  }
}
