//
//  AppDelegate.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 27/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

// swiftlint:disable line_length
import UIKit
import NeedleFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    registerProviderFactories()
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window

    let rootComponent = RootComponent()
    window.rootViewController = rootComponent.rootViewController

    window.makeKeyAndVisible()
//    guard let randomUsersClientTabBarController = window?.rootViewController as? RandomUsersClientTabBarController else {
//      return true
//    }
//    let realmService = RealmService()
//    let inMemoryCacheCapacity = 4 * 1024 * 1024
//    let onDiskCacheCapacity = 20 * 1024 * 1024
////    let urlCache = URLCache.init(memoryCapacity: inMemoryCacheCapacity, diskCapacity: onDiskCacheCapacity, diskPath: nil)
//    URLCache.shared.memoryCapacity = inMemoryCacheCapacity
//    URLCache.shared.diskCapacity = onDiskCacheCapacity
//    randomUsersClientTabBarController.realmService = realmService

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

}
