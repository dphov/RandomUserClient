//
//  RUCUsersListComponent.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import NeedleFoundation
import UIKit

protocol RUCUsersListDependency: Dependency {
  var realmServiceMethods: RealmServiceMethods { get }
  var rucUserInfoComponent: RUCUserInfoComponent { get }
}

class RUCUsersListComponent: Component<RUCUsersListDependency>, RUCUsersListBuilder {
  var rucUsersListViewController: UIViewController {
    return RUCUsersListViewController(realmServiceMethods: dependency.realmServiceMethods, usersInfoController: rucUsersListInfoController, rucUserInfoBuilder: dependency.rucUserInfoComponent)
  }
  var rucUsersListInfoController: RUCUsersListInfoController {
    return RUCUsersListInfoControllerImpl()
  }
}

protocol RUCUsersListBuilder {
  var rucUsersListViewController: UIViewController { get }
}
