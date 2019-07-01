//
//  RUCFavoritesComponent.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import NeedleFoundation
import UIKit

protocol RUCFavoritesDependency: Dependency {
  var realmServiceMethods: RealmServiceMethods { get }
  var rucUserInfoComponent: RUCUserInfoComponent { get }
}

class RUCFavoritesComponent: Component<RUCFavoritesDependency>, RUCFavoritesBuilder {
  var rucFavoritesViewController: UIViewController {
    return RUCFavoritesViewController(realmServiceMethods: dependency.realmServiceMethods, rucUserInfoBuilder: dependency.rucUserInfoComponent)
  }
}

protocol RUCFavoritesBuilder {
  var rucFavoritesViewController: UIViewController { get }
}
