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
  //TODO: Make featured button 

  var userObject: RandomUserDataModel = RandomUserDataModel()
  override func viewDidLoad() {
      super.viewDidLoad()
      self.tableView.register(UINib(nibName: "UserInfoTopCell", bundle: nil), forCellReuseIdentifier: "UserInfoTopCell")
      self.tableView.register(UINib(nibName: "UserLocationCell", bundle: nil), forCellReuseIdentifier: "UserLocationCell")
      self.tableView.register(UINib(nibName: "UserAdressCell", bundle: nil), forCellReuseIdentifier: "UserAdressCell")
      self.tableView.register(UINib(nibName: "UserTimezoneCell", bundle: nil), forCellReuseIdentifier: "UserTimezoneCell")
      self.tableView.register(UINib(nibName: "UserLoginCell", bundle: nil), forCellReuseIdentifier: "UserLoginCell")
      self.tableView.register(UINib(nibName: "UserDateAgeDisplayCell", bundle: nil), forCellReuseIdentifier: "UserDateAgeDisplayCell")
      self.tableView.register(UINib(nibName: "UserIDCell", bundle: nil), forCellReuseIdentifier: "UserIDCell")
      self.tableView.register(UINib(nibName: "UserOtherDataCell", bundle: nil), forCellReuseIdentifier: "UserOtherDataCell")
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
        let url = URL(string: (userObject.picture?.large!)!)
        var data: Data = Data()
        if InternetReachiability.isConnectedToNetwork() {
          DispatchQueue.global().async {
            data = try! Data(contentsOf: url!)
            DispatchQueue.main.async {
              userInfoTopCell.userAvatarImageView.image = UIImage(data: data)
            }
          }
        }
        userInfoTopCell.firstNameLabel.text = userObject.name?.first?.capitalized
        userInfoTopCell.lastNameLabel.text = userObject.name?.last?.capitalized
        return userInfoTopCell
    case 1:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      userLocationCell = tableView.dequeueReusableCell(withIdentifier: "UserLocationCell", for: indexPath) as! UserLocationCell
      userLocationCell.userLocationMapView.mapType = .standard
      if ((userObject.location?.coordinates?.latitude) != nil) {
        userLocationCell.userLocationMapView.setRegion(MKCoordinateRegion.init(center:
          CLLocationCoordinate2D(
            latitude: (userObjectLocation.coordinates?.latitude!.doubleValue)!,
            longitude: (userObjectLocation.coordinates?.longitude!.doubleValue)!),
          latitudinalMeters: 1000, longitudinalMeters: 1000),
          animated: true)
      } else {
        return userLocationCell
      }
      return userLocationCell
    case 2:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      userAdressCell = tableView.dequeueReusableCell(withIdentifier: "UserAdressCell", for: indexPath) as! UserAdressCell
      if let userObjectLocationCity: String = userObjectLocation.city,
        let userObjectLocationState: String = userObjectLocation.state,
        let userObjectLocationStreet: String = userObjectLocation.street {
        userAdressCell.cityLabel.text = "City: " + userObjectLocationCity.capitalized
        userAdressCell.postcodeLabel.text = "Postcode: " + String(userObjectLocation.postcode)
        userAdressCell.stateLabel.text = "State: " + userObjectLocationState.capitalized
        userAdressCell.streetLabel.text = "Street: " + userObjectLocationStreet.capitalized
        return userAdressCell
      } else {
        return userAdressCell
      }
    case 3:
      guard let userObjectLocation: RandomUserDataLocationModel = userObject.location else {
        return cell
      }
      guard let userObjectTimezone: RandomUserDataLocationTimezoneModel = userObjectLocation.timezone else {
        return cell
      }
      userTimezoneCell = tableView.dequeueReusableCell(withIdentifier: "UserTimezoneCell", for: indexPath) as! UserTimezoneCell
      if let userObjectTimezoneOffset: String = userObjectTimezone.offset,
        let userObjectTimezoneDescription: String = userObjectTimezone.zoneDescription {

        userTimezoneCell.offsetLabel.text = "Offset: " + userObjectTimezoneOffset
        userTimezoneCell.descriptionLabel.text = "Description: " + userObjectTimezoneDescription
        return userTimezoneCell
      } else {
        return userTimezoneCell
      }
    case 4:
      guard let userObjectLogin: RandomUserDataLoginModel = userObject.login else {
        return cell
      }
      userLoginCell = tableView.dequeueReusableCell(withIdentifier: "UserLoginCell", for: indexPath) as! UserLoginCell
      if let userObjectLoginMD5 = userObjectLogin.md5,
        let userObjectLoginSalt = userObjectLogin.salt,
        let userObjectLoginSHA1 = userObjectLogin.sha1,
        let userObjectLoginSHA256 = userObjectLogin.sha256,
        let userObjectLoginUsername = userObjectLogin.username,
        let userObjectLoginPassword = userObjectLogin.password,
        let userObjectLoginUUID = userObjectLogin.uuid {
      userLoginCell.md5Label.text = "MD5: " + userObjectLoginMD5
      userLoginCell.passwordLabel.text = "Password: " + userObjectLoginPassword
      userLoginCell.saltLabel.text = "Salt: " + userObjectLoginSalt
      userLoginCell.sha1Label.text = "SHA1: " + userObjectLoginSHA1
      userLoginCell.sha256Label.text = "SHA256: " + userObjectLoginSHA256
      userLoginCell.usernameLabel.text = "Username: " + userObjectLoginUsername
      userLoginCell.uuidLabel.text = "UUID: " + userObjectLoginUUID
      }
      return userLoginCell
    case 5:
      guard let userObjectDOB: RandomUserDataDOBModel = userObject.dob else {
        return cell
      }
      userDOBCell = tableView.dequeueReusableCell(withIdentifier: "UserDateAgeDisplayCell", for: indexPath) as! UserDateAgeDisplayCell
      if let userObjectDOBDate = userObjectDOB.date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: userObjectDOBDate) {
          dateFormatter.dateFormat = "MM/dd/yyyy"
          userDOBCell.dateLabel.text = "Date: " +
          dateFormatter.string(from: date)
        }
        userDOBCell.headerLabel.text = "Date of birth"
        userDOBCell.ageLabel.text = "Age: " + String(userObjectDOB.age)
      }
      return userDOBCell
    case 6:
      guard let userObjectRegistered: RandomUserDataRegisteredModel = userObject.registered else {
        return cell
      }
      userRegisteredCell = tableView.dequeueReusableCell(withIdentifier: "UserDateAgeDisplayCell", for: indexPath) as! UserDateAgeDisplayCell
      if let userObjectRegisteredDate = userObjectRegistered.date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: userObjectRegisteredDate) {
          dateFormatter.dateFormat = "MM/dd/yyyy"
          userRegisteredCell.dateLabel.text = "Date: " + dateFormatter.string(from: date)
        }
        userRegisteredCell.headerLabel.text = "Date of registration"

        userRegisteredCell.ageLabel.text = "Age: " + String(userObjectRegistered.age)
      }
      return userRegisteredCell

    case 7:
      guard let userObjectID: RandomUserDataIDModel = userObject.dataId else {
        return cell
      }
      userIDCell = tableView.dequeueReusableCell(withIdentifier: "UserIDCell", for: indexPath) as! UserIDCell
      if let  userObjectIDName = userObjectID.name,
        let userObjectIDValue = userObjectID.value {
        userIDCell.typeOfIdLabel.text = "Type of ID: " + userObjectIDName
        userIDCell.valueLabel.text = "Value: " + userObjectIDValue
      }
      return userIDCell
    case 8:
      userOtherDataCell = tableView.dequeueReusableCell(withIdentifier: "UserOtherDataCell", for: indexPath) as! UserOtherDataCell
      if let userObjectCell = userObject.cell,
        let userObjectPhone  = userObject.phone,
        let userObjectEmail = userObject.email,
        let userObjectNat = userObject.nat,
        let userObjectGender = userObject.gender {
      userOtherDataCell.cellLabel.text = "Cell: " + userObjectCell
      userOtherDataCell.phoneLabel.text = "Phone: " + userObjectPhone
      userOtherDataCell.emailLabel.text = "E-mail: " + userObjectEmail
      userOtherDataCell.natLabel.text = "Nationality: " + userObjectNat
      userOtherDataCell.genderLabel.text = "Gender: " + userObjectGender
      }
      return userOtherDataCell
    default:
        cell = UITableViewCell()
        return cell
    }
  }
}

