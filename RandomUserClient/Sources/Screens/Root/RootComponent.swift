//
//  RootComponent.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import NeedleFoundation
import UIKit

class RootComponent: BootstrapComponent {
  var realmServiceMethods: RealmServiceMethods {
    return shared { RealmServiceImpl() }
  }
  var rootViewController: UIViewController {
    return RootViewController(realmService: realmServiceMethods, rucTabBarBuilder: rucTabBarComponent)
  }
  var rucTabBarComponent: RUCTabBarComponent {
    return RUCTabBarComponent(parent: self)
  }
  var rucUserInfoComponent: RUCUserInfoComponent {
    return RUCUserInfoComponent(parent: self)
  }
}
