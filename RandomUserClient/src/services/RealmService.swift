//
//  RealmService.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import RealmSwift

class RealmService {
  init() {}

  func create< T: Object> (_ object: T) {
    DispatchQueue(label: "background").async {
      let realm = try! Realm()
      do {
        try realm.write {
          realm.add(object, update: true)
        }
      } catch {
        self.post(error)
      }
    }
  }
  func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
    DispatchQueue(label: "background").async {
      let realm = try! Realm()
      do {
        try realm.write {
          for (key, value) in dictionary {
            object.setValue(value, forKey: key)
          }
        }
      } catch {
        self.post(error)
      }
    }
  }
  func delete< T: Object> (_ object: T) {
    DispatchQueue(label: "background").async {
      let realm = try! Realm()
      do {
        try realm.write {
          realm.delete(object)
        }
      } catch {
        self.post(error)
      }
    }
  }

  func getObjects<T: Object> (_ object: T.Type) -> Results<T> {
    let realm = try! Realm()
    return realm.objects(object)
  }

  func post(_ error: Error) {
    NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
  }

  func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
    NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
      completion(notification.object as? Error)
    }
  }

  func stopObservingErrors(in vc: UIViewController) {
    NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
  }
}
