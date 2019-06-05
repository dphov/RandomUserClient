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
      return 9
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell = UITableViewCell()
    var userInfoTopCell: UserInfoTopCell
    var userLocationCell: UserLocationCell
    var userAdressCell: UserAdressCell
    var userTimezoneCell: UserTimezoneCell
    var userLoginCell: UserLoginCell
    var userDOBCell: UserDateAgeDisplayCell
    var userRegisteredCell: UserDateAgeDisplayCell
    var userIDCell: UserIDCell
    var userOtherDataCell: UserOtherDataCell

    switch indexPath.section {
    case 0:
        userInfoTopCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTopCell", for: indexPath) as! UserInfoTopCell
        userInfoTopCell.setup(userObject)
        return userInfoTopCell
    case 1:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      userLocationCell = tableView.dequeueReusableCell(withIdentifier: "UserLocationCell", for: indexPath) as! UserLocationCell
      userLocationCell.setup(userObjectLocation)
      return userLocationCell
    case 2:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      userAdressCell = tableView.dequeueReusableCell(withIdentifier: "UserAdressCell", for: indexPath) as! UserAdressCell
      userAdressCell.setup(userObjectLocation)
      return userAdressCell
    case 3:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location,
            let userObjectTimezone: RandomUserDataLocationTimezoneModel = userObjectLocation.timezone else {
        return cell
      }
      userTimezoneCell = tableView.dequeueReusableCell(withIdentifier: "UserTimezoneCell", for: indexPath) as! UserTimezoneCell
      userTimezoneCell.setup(userObjectTimezone)
      return userTimezoneCell
    case 4:
      guard let userObjectLogin: RandomUserDataLoginModel = userObject.login else {
        return cell
      }
      userLoginCell = tableView.dequeueReusableCell(withIdentifier: "UserLoginCell", for: indexPath) as! UserLoginCell
      userLoginCell.setup(userObjectLogin)
      return userLoginCell
    case 5:
      guard let userObjectDOB: RandomUserDataDOBModel = userObject.dob else {
        return cell
      }
      userDOBCell = tableView.dequeueReusableCell(withIdentifier: "UserDateAgeDisplayCell", for: indexPath) as! UserDateAgeDisplayCell
      userDOBCell.setup(userObjectDOB)
      return userDOBCell
    case 6:
      guard let userObjectRegistered: RandomUserDataRegisteredModel = userObject.registered else {
        return cell
      }
      userRegisteredCell = tableView.dequeueReusableCell(withIdentifier: "UserDateAgeDisplayCell", for: indexPath) as! UserDateAgeDisplayCell
      userRegisteredCell.setup(userObjectRegistered)
      return userRegisteredCell
    case 7:
      guard let userObjectID: RandomUserDataIDModel = userObject.dataId else {
        return cell
      }
      userIDCell = tableView.dequeueReusableCell(withIdentifier: "UserIDCell", for: indexPath) as! UserIDCell
      userIDCell.setup(userObjectID)
      return userIDCell
    case 8:
      userOtherDataCell = tableView.dequeueReusableCell(withIdentifier: "UserOtherDataCell", for: indexPath) as! UserOtherDataCell
      userOtherDataCell.setup(userObject)
      return userOtherDataCell
    default:
        cell = UITableViewCell()
        return cell
    }
  }
}
