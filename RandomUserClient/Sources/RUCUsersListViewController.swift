//
//  RUCUsersListViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
import RealmSwift

class RUCUsersListViewController: UIViewController {
  private let realmServiceMethods: RealmServiceMethods
  private var usersListInfoController: RUCUsersListInfoController
  private var rucUserInfoBuilder: RUCUserInfoBuilder
  private let userDetailsSegueId = "ShowUserDetailsSegue"
  private let usersListTableViewCellId = "UsersListTableViewCell"
  private var notificationToken: NotificationToken?
  @IBOutlet weak var usersNavBar: UINavigationBar!
  @IBOutlet weak var usersTableView: UITableView!
  @IBAction func refreshUsersDataAction() {
    addUsersData(isNeedToUpdate: true)
    self.refreshControl.endRefreshing()
  }
  private let refreshControl = UIRefreshControl()
  var results: Results<RandomUserDataModel>? {
    return realmServiceMethods.getObjects(RandomUserDataModel.self)
  }
  init(realmServiceMethods: RealmServiceMethods, usersInfoController: RUCUsersListInfoController, rucUserInfoBuilder: RUCUserInfoBuilder) {
    self.realmServiceMethods = realmServiceMethods
    self.usersListInfoController = usersInfoController
    self.rucUserInfoBuilder = rucUserInfoBuilder
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupNotificationToken() {
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
  func setup() {
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    usersTableView.delegate = self
    usersTableView.dataSource = self
    usersTableView.register(UINib(nibName: usersListTableViewCellId, bundle: nil), forCellReuseIdentifier: usersListTableViewCellId)
    usersTableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
    addUsersData()
    usersTableView.addSubview(self.refreshControl)
    refreshControl.addTarget(self, action: #selector(RUCUsersListViewController.refreshUsersDataAction), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(string: "Pull down for wipeing table...", attributes: nil)
    setupNotificationToken()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
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
    if resCount <= usersListInfoController.lastPage {
      return currentPage + 1
    }
    return 0
  }
  func addUsersData(isNeedToUpdate update: Bool = false) {
    usersListInfoController.fetchingMore = true
    var page: Int {
      if update {
        return 1
      } else {
        return getNextPageIndex(elemPerPage: 10)
      }
    }
    usersListInfoController.fetchUsersData(forPage: page) { (data) in
      guard let usersData = data else {return}
      if update {
        self.realmServiceMethods.deleteAll()
      }
      if let unwrappedUsersDataResults = usersData.results,
        let unwrappedResults = self.results {
        for user in unwrappedUsersDataResults {
          let obj = RandomUserDataModel(value: user)
          if update {
            self.realmServiceMethods.create(obj, update: update)
          } else {
            if unwrappedResults.filter({$0.id == obj.id}).isEmpty {
              self.realmServiceMethods.create(obj, update: false)
            }
          }
        }
        self.usersListInfoController.fetchingMore = false
      }
    }
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
extension RUCUsersListViewController: UsersListTableViewCellDelegate {
  func changeInFavoritesStatus(_ cell: UsersListTableViewCell) {
    if let indexPath = usersTableView.indexPath(for: cell),
      let unwrappedResults = results {
      let selectedRow = indexPath.row
      let selectedUser: RandomUserDataModel = unwrappedResults[selectedRow]
      if let selectedUserId = selectedUser.id,
        let unwrappedSelectedUser = realmServiceMethods.getSpecificObject(RandomUserDataModel.self, primaryKey: selectedUserId) {
        if unwrappedSelectedUser.isInFavorites == "true" {
          realmServiceMethods.update(unwrappedSelectedUser, with: ["isInFavorites": "false"])
          cell.favouritesButton.imageView?.image = UIImage.init(named: "star")
        } else {
          realmServiceMethods.update(unwrappedSelectedUser, with: ["isInFavorites": "true"])
          cell.favouritesButton.imageView?.image = UIImage.init(named: "star-filled")
        }
      }
    }
  }
}

// MARK: - UITableViewDelegate
extension RUCUsersListViewController: UITableViewDelegate {
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
    } else if section == 1 && usersListInfoController.fetchingMore {
      return 1
    }
    return 0
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    // TODO: fix update of 2 sections
    return 1
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let indexPath = usersTableView.indexPathForSelectedRow,
      let unwrappedResults = results {
      let selectedRow = indexPath.row
      let selectedUser: RandomUserDataModel = unwrappedResults[selectedRow]
        if let userInfoVC = rucUserInfoBuilder.rucUserInfoViewController as? RUCUserInfoViewController {
          if let selectedUserId = selectedUser.id {
            userInfoVC.userObjectId = selectedUserId
          }
          self.navigationController?.pushViewController(userInfoVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if offsetY > contentHeight - scrollView.frame.height * 4 {
      if !usersListInfoController.fetchingMore {
        addUsersData()
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension RUCUsersListViewController: UITableViewDataSource {
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
