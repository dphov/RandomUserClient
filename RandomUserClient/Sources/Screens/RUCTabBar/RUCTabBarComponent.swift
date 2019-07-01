//
//  RUCTabBarComponent.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
import NeedleFoundation

protocol RUCTabBarDependency: Dependency {
  var realmServiceMethods: RealmServiceMethods { get }
}

class RUCTabBarComponent: Component<RUCTabBarDependency>, RUCTabBarBuilder {
  var rucTabBarController: UITabBarController {
    return RUCTabBarController(realmServiceMethods: dependency.realmServiceMethods, rucUsersListBuilder: rucUsersListComponent, rucFavoritesBuilder: rucFavoritesComponent)
  }

  var rucUsersListComponent: RUCUsersListComponent {
    return RUCUsersListComponent(parent: self)
  }

  var rucFavoritesComponent: RUCFavoritesComponent {
    return RUCFavoritesComponent(parent: self)
  }
}

protocol RUCTabBarBuilder {
  var rucTabBarController: UITabBarController { get }
}
