//
//  RootViewController.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  private let realmService: RealmServiceMethods
  private let rucTabBarBuilder: RUCTabBarBuilder

  init(realmService: RealmServiceMethods, rucTabBarBuilder: RUCTabBarBuilder) {
    self.realmService = realmService
    self.rucTabBarBuilder = rucTabBarBuilder
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidAppear(_ animated: Bool) {
    self.present(viewController: rucTabBarBuilder.rucTabBarController)
    self.view.backgroundColor = .white
  }
  private func present(viewController: UIViewController) {
    if presentedViewController == viewController {
      return
    }
    if presentedViewController != nil {
      dismiss(animated: true) {
        self.present(viewController, animated: true, completion: nil)
      }
    } else {
      present(viewController, animated: true, completion: nil)
    }
  }
}
