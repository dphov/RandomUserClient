//
//  FavouritesViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//


import UIKit
import RealmSwift

class FavoritesViewController: UIViewController, ServiceableByRealm {
  var realmService: RealmService?
  var results: Results<RandomUserDataModel>? {
    if let unwrappedRealmService = realmService {
      return unwrappedRealmService.getObjects(RandomUserDataModel.self).filter("isInFavorites = 'true'")
    } else {
      return nil
    }
  }
  var notificationToken: NotificationToken?
  func favFilter(_ user: RandomUserDataModel) -> Bool {
    if user.isInFavorites == "true" {
      return true
    } else {
      return false
    }
  }
  var filteredResults: LazyFilterSequence<Results<RandomUserDataModel>>?
  func filterResults(_ res: Results<RandomUserDataModel>) -> LazyFilterSequence<Results<RandomUserDataModel>>? {
    if let res = results {
      return res.filter({$0.isInFavorites == "true"})
    } else {
      return nil
    }
  }
  @IBOutlet weak var favoritesTableView: UITableView!

  func setup() {
    favoritesTableView.delegate = self
    favoritesTableView.dataSource = self
    favoritesTableView.register(UINib(nibName: "UsersListTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersListTableViewCell")
    guard let unwrappedResults = results else {return}
    filteredResults = filterResults(unwrappedResults)
    notificationToken = unwrappedResults.observe { [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.favoritesTableView else { return }
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
      // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool) {
    if let unwrappedResults = results {
      filteredResults = filterResults(unwrappedResults)
    }
    favoritesTableView.reloadData()
  }
  deinit {
    if let token = notificationToken {
      token.invalidate()
    }
  }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {

}
// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let unwrappedFilteredResults = filteredResults {
      return unwrappedFilteredResults.count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "UsersListTableViewCell", for: indexPath) as? UsersListTableViewCell
        else {return UITableViewCell()}
      if let unwrappedFilteredResults = filteredResults,
        let rowItemPicture = unwrappedFilteredResults[indexPath.row].picture,
        let rowItemPictureMedium = rowItemPicture.medium,
        let rowItemName = unwrappedFilteredResults[indexPath.row].name,
        let rowItemNameFirst = rowItemName.first,
        let rowItemNameLast = rowItemName.last {
        let url = URL(string: rowItemPictureMedium)
        var data: Data = Data()
        
        cell.favouritesButton.imageView?.image = UIImage(named: "star-filled")
        cell.userNameLabel.text = rowItemNameFirst.capitalized + " " + rowItemNameLast.capitalized
        cell.emailLabel.text = unwrappedFilteredResults[indexPath.row].email
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

// MARK: - UsersListTableViewCellDelegate
extension FavoritesViewController: UsersListTableViewCellDelegate {
  func changeInFavoritesStatus(_ cell: UsersListTableViewCell) {
    if let indexPath = favoritesTableView.indexPath(for: cell),
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
