//
//  RealmService.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 01/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

// swiftlint:disable force_try

import RealmSwift

protocol ServiceableByRealm {
  var realmService: RealmService? { get set }
}

class RealmService {
  init() {}

  let realm = try! Realm()

  func create< T: Object> (_ object: T, update isNeedUpdate: Bool = false) {
    let realm = try! Realm()
    do {
      try realm.write {
        realm.add(object, update: isNeedUpdate)
      }
    } catch {
      self.post(error)
    }
  }
  func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
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
  func update<T: Object>(_ object: T) {
    let objectRef = ThreadSafeReference.init(to: object)
    DispatchQueue(label: "background").async {
      let realm = try! Realm()
      guard let object = realm.resolve(objectRef) else {
        return
      }
      do {
        try realm.write {
          realm.add(object, update: true)
        }
      } catch {
        self.post(error)
      }
    }
  }
  func delete< T: Object> (_ object: T) {
    let realm = try! Realm()
    do {
      try realm.write {
        realm.delete(object)
      }
    } catch {
      self.post(error)
    }
  }

  func deleteAll() {
    let realm = try! Realm()
    do {
      try realm.write {
        realm.deleteAll()
      }
    } catch {
      self.post(error)
    }
  }

  func getObjects<T: Object> (_ object: T.Type) -> Results<T> {
    let realm = try! Realm()
    return realm.objects(object)
  }

  func getSpecificObject<T: Object> (_ object: T.Type, primaryKey: String) -> T? {
    let realm = try! Realm()
    return realm.object(ofType: object, forPrimaryKey: primaryKey)
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
