//
//  UserInfoTableViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
import MapKit

class UserInfoTableViewController: UITableViewController {
  var userObject: RandomUserDataModel = RandomUserDataModel()
  var cellsForRegister = ["UserInfoTopCell", "UserLocationCell", "UserAdressCell",
                          "UserTimezoneCell", "UserLoginCell", "UserDateAgeDisplayCell",
                          "UserIDCell", "UserOtherDataCell"]

  func registerCells(cellsForRegister: [String]) {
    for id in cellsForRegister {
      self.tableView.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
    }
  }

  func setup() {
    tableView.allowsSelection = false
    registerCells(cellsForRegister: cellsForRegister)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
      return cellsForRegister.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
