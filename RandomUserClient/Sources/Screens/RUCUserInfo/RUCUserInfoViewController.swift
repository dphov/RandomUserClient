//
//  RUCUserInfoViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/07/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class RUCUserInfoViewController: UIViewController {
  private let realmServiceMethods: RealmServiceMethods
  private var userObject: RandomUserDataModel = RandomUserDataModel()
  var userObjectId: String = ""
  private var changeInFavoritesStatusButton = UIBarButtonItem.init()
//  @IBOutlet weak var containerViewUserInfoTableViewController: UIView!
  @IBOutlet weak var userInfoTableView: UITableView!
  @IBAction func changeInFavoritesStatus() {
    if let userObj = realmServiceMethods.getSpecificObject(RandomUserDataModel.self, primaryKey: userObjectId) {
      if userObj.isInFavorites == "true" {
        realmServiceMethods.update(userObj, with: ["isInFavorites": "false"])
        self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "star")
      } else {
        realmServiceMethods.update(userObj, with: ["isInFavorites": "true"])
        self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "star-filled")
      }
    }
  }
  init(realmServiceMethods: RealmServiceMethods) {
    self.realmServiceMethods = realmServiceMethods
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  var cellsForRegister = ["UserInfoTopCell", "UserLocationCell", "UserAdressCell",
                          "UserTimezoneCell", "UserLoginCell", "UserDateAgeDisplayCell",
                          "UserIDCell", "UserOtherDataCell"]
  func registerCells(tableView: UITableView, cellsForRegister: [String]) {
    for id in cellsForRegister {
      tableView.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
    }
  }
  func setupTableViewController(_ tableVC: UITableViewController) {
    tableVC.tableView = userInfoTableView
    tableVC.tableView.delegate = self
    tableVC.tableView.dataSource = self
    tableVC.tableView.allowsSelection = false
    registerCells(tableView: tableVC.tableView, cellsForRegister: cellsForRegister)
  }
  func setup() {
    if let newUserObject = realmServiceMethods.getSpecificObject(RandomUserDataModel.self, primaryKey: userObjectId) {
      self.userObject = newUserObject
      if newUserObject.isInFavorites == "true" {
        changeInFavoritesStatusButton.image = UIImage.init(named: "star-filled")
      } else {
        changeInFavoritesStatusButton.image = UIImage.init(named: "star")
      }
    }
    changeInFavoritesStatusButton.style = .plain
    changeInFavoritesStatusButton.target = self
    changeInFavoritesStatusButton.action = Selector(("changeInFavoritesStatus"))
    self.navigationItem.rightBarButtonItem = changeInFavoritesStatusButton

    setupTableViewController(UITableViewController())
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "showUserInfoSegue" {
//      if let newUserObject = realmServiceMethods.getSpecificObject(RandomUserDataModel.self, primaryKey: userObjectId),
//        let userInfo = segue.destination as? UserInfoTableViewController {
//        userInfo.userObject = newUserObject
//      }
//    }
//  }
}


extension RUCUserInfoViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return cellsForRegister.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = UITableViewCell()

    switch indexPath.section {
    case 0:
      if let userInfoTopCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTopCell", for: indexPath) as? UserInfoTopCell {
        userInfoTopCell.setup(userObject)
        return userInfoTopCell
      } else { return cell }
    case 1:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      if let userLocationCell = tableView.dequeueReusableCell(withIdentifier: "UserLocationCell", for: indexPath) as? UserLocationCell {
        userLocationCell.setup(userObjectLocation)
        return userLocationCell
      } else { return cell }
    case 2:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      if let userAdressCell = tableView.dequeueReusableCell(withIdentifier: "UserAdressCell", for: indexPath) as? UserAdressCell {
        userAdressCell.setup(userObjectLocation)
        return userAdressCell
      } else { return cell }
    case 3:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location,
        let userObjectTimezone: RandomUserDataLocationTimezoneModel = userObjectLocation.timezone else {
          return cell
      }
      if let userTimezoneCell = tableView.dequeueReusableCell(withIdentifier: "UserTimezoneCell", for: indexPath) as? UserTimezoneCell {
        userTimezoneCell.setup(userObjectTimezone)
        return userTimezoneCell
      } else { return cell }
    case 4:
      guard let userObjectLogin: RandomUserDataLoginModel = userObject.login else {
        return cell
      }
      if let userLoginCell = tableView.dequeueReusableCell(withIdentifier: "UserLoginCell", for: indexPath) as? UserLoginCell {
        userLoginCell.setup(userObjectLogin)
        return userLoginCell
      } else { return cell }
    case 5:
      guard let userObjectDOB: RandomUserDataDOBModel = userObject.dob else {
        return cell
      }
      if let userDOBCell = tableView.dequeueReusableCell(withIdentifier: "UserDateAgeDisplayCell", for: indexPath) as? UserDateAgeDisplayCell {
        userDOBCell.setup(userObjectDOB)
        return userDOBCell
      } else { return cell }
    case 6:
      guard let userObjectRegistered: RandomUserDataRegisteredModel = userObject.registered else {
        return cell
      }
      if let userRegisteredCell = tableView.dequeueReusableCell(withIdentifier: "UserDateAgeDisplayCell", for: indexPath) as? UserDateAgeDisplayCell {
        userRegisteredCell.setup(userObjectRegistered)
        return userRegisteredCell
      } else { return cell }
    case 7:
      guard let userObjectID: RandomUserDataIDModel = userObject.dataId else {
        return cell
      }
      if let userIDCell = tableView.dequeueReusableCell(withIdentifier: "UserIDCell", for: indexPath) as? UserIDCell {
        userIDCell.setup(userObjectID)
        return userIDCell
      } else { return cell }
    case 8:
      if let userOtherDataCell = tableView.dequeueReusableCell(withIdentifier: "UserOtherDataCell", for: indexPath) as? UserOtherDataCell {
        userOtherDataCell.setup(userObject)
        return userOtherDataCell
      } else { return cell }
    default:
      return cell
    }
  }
}

extension RUCUserInfoViewController: UITableViewDelegate {

}
