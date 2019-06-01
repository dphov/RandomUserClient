//
//  RandomUsersClientTabBarController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
class RandomUsersClientTabBarController: UITabBarController {
  var realmService: RealmService?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var vc = self.viewControllers?.first?.children.first as? ServiceableByRealm
    vc?.realmService = self.realmService
  }

  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    if item.title == "Users" {
      var vc = self.viewControllers?.first?.children.first as? ServiceableByRealm
      vc?.realmService = self.realmService
    } else {
      var vc = self.viewControllers?[1].children.first as? ServiceableByRealm
      vc?.realmService = self.realmService
    }
  }
}
