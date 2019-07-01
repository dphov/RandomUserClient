//
//  RUCUserInfoController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/07/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//
import NeedleFoundation
import UIKit

protocol RUCUserInfoDependency: Dependency {
  var realmServiceMethods: RealmServiceMethods { get }
}

class RUCUserInfoComponent: Component<RUCUserInfoDependency>, RUCUserInfoBuilder {
  var rucUserInfoViewController: UIViewController {
    return RUCUserInfoViewController(realmServiceMethods: dependency.realmServiceMethods)
  }
}

protocol RUCUserInfoBuilder {
  var rucUserInfoViewController: UIViewController { get }
}
