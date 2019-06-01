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
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
      return 2
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell
    var cell1: UserInfoTopCell
    var cell2: UserLocationCell
    switch indexPath.section {
    case 0:
        cell1 = tableView.dequeueReusableCell(withIdentifier: "UserInfoTopCell", for: indexPath) as! UserInfoTopCell
        let url = URL(string: (userObject.picture?.large!)!)
        var data: Data = Data()
        if InternetReachiability.isConnectedToNetwork() {
          DispatchQueue.global().async {
            data = try! Data(contentsOf: url!)
            DispatchQueue.main.async {
              cell1.userAvatarImageView.image = UIImage(data: data)
            }
          }
        }
        cell1.firstNameLabel.text = userObject.name?.first?.capitalized
        cell1.lastNameLabel.text = userObject.name?.last?.capitalized
        return cell1
    case 1:
      cell2 = tableView.dequeueReusableCell(withIdentifier: "UserLocationCell", for: indexPath) as! UserLocationCell
      //cell2.userLocationMapView.delegate = self
      cell2.userLocationMapView.mapType = .standard
      if ((userObject.location?.coordinates?.latitude) != nil) {
        cell2.userLocationMapView.setRegion(MKCoordinateRegion.init(center:
          CLLocationCoordinate2D(
            latitude: (userObject.location?.coordinates?.latitude!.doubleValue)!,
            longitude: (userObject.location?.coordinates?.longitude!.doubleValue)!),
          latitudinalMeters: 1000, longitudinalMeters: 1000),
          animated: true)
        return cell2
      } else {
        return UITableViewCell()
      }
    default:
        cell = UITableViewCell()
        return cell
    }
  }
}

