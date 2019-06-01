//
//  UserInfoViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit


class UserInfoViewController: UIViewController {
  
  var userObject: RandomUserDataModel = RandomUserDataModel()

  @IBOutlet weak var containerViewUserInfoTableViewController: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showUserInfoSegue" {
      if let userInfo = segue.destination as? UserInfoTableViewController {
        userInfo.userObject = self.userObject
      }
    }
  }
}
