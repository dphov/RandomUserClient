//
//  RandomUsersClientTabBarController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class RUCTabBarController: UITabBarController {
  private var realmServiceMethods: RealmServiceMethods
  private let rucUsersListBuilder: RUCUsersListBuilder
  private let rucFavoritesBuilder: RUCFavoritesBuilder
  init(realmServiceMethods: RealmServiceMethods, rucUsersListBuilder: RUCUsersListBuilder, rucFavoritesBuilder: RUCFavoritesBuilder) {
    self.realmServiceMethods = realmServiceMethods
    self.rucUsersListBuilder = rucUsersListBuilder
    self.rucFavoritesBuilder = rucFavoritesBuilder
    super.init(nibName: nil, bundle: nil)
    print(self.description)

  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = .white
    let usersListVC = rucUsersListBuilder.rucUsersListViewController
    let favoritesVC = rucFavoritesBuilder.rucFavoritesViewController
    let tabOneBarItem = UITabBarItem(title: "Users",
                                     image: UIImage(named: "user"), tag: 0)
    let tabTwoBarItem = UITabBarItem(title: "Favorites",
                                     image: UIImage(named: "star"), tag: 1)
    var controllerArray: [UIViewController]

    usersListVC.tabBarItem = tabOneBarItem
    usersListVC.title = "Users"
    favoritesVC.tabBarItem = tabTwoBarItem
    favoritesVC.title = "Favorites"
    controllerArray = [usersListVC, favoritesVC]
    self.viewControllers = controllerArray.map {
      return UINavigationController.init(rootViewController: $0)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}


