//
//  UserInfoViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController, ServiceableByRealm {
  var realmService: RealmService?
  var userObject: RandomUserDataModel = RandomUserDataModel()
  var userObjectId: String = ""
  @IBOutlet weak var containerViewUserInfoTableViewController: UIView!
  var changeInFavoritesStatusButton = UIBarButtonItem.init()

  @IBAction func changeInFavoritesStatus() {
    if let userObj = realmService?.getSpecificObject(RandomUserDataModel.self, primaryKey: userObjectId) {
      if userObj.isInFavorites == "true" {
        realmService?.update(userObj, with: ["isInFavorites": "false"])
        self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "star")
      } else {
        realmService?.update(userObj, with: ["isInFavorites": "true"])
        self.navigationItem.rightBarButtonItem?.image = UIImage.init(named: "star-filled")
      }
    }
  }

  func setup() {
    if let newUserObject = realmService?.getSpecificObject(RandomUserDataModel.self, primaryKey: userObjectId) {
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
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserInfoSegue" {
      if let newUserObject = realmService?.getSpecificObject(RandomUserDataModel.self, primaryKey: userObjectId),
         let userInfo = segue.destination as? UserInfoTableViewController {
        userInfo.userObject = newUserObject
      }
    }
  }
}
