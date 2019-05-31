//
//  UsersViewModel.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 30/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import RealmSwift
import Realm

final class RandomUserDataNameModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var title: String?
  @objc dynamic var first: String?
  @objc dynamic var last: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataLocationCoordinatesModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var latitude: String?
  @objc dynamic var longitude: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataLocationTimezoneModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var offset: String?
  @objc dynamic var zoneDescription: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataLocationModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var street: String?
  @objc dynamic var city: String?
  @objc dynamic var state: String?
  @objc dynamic var postcode: Int = 0
  @objc dynamic var coordinates: RandomUserDataLocationCoordinatesModel?
  @objc dynamic var timezone: RandomUserDataLocationTimezoneModel?
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataLoginModel: Object {
  @objc dynamic var uuid: String?
  @objc dynamic var username: String?
  @objc dynamic var password: String?
  @objc dynamic var salt: String?
  @objc dynamic var md5: String?
  @objc dynamic var sha1: String?
  @objc dynamic var sha256: String?
  override static func primaryKey() -> String? {
    return "uuid"
  }
}

final class RandomUserDataDOBModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var date: String?
  @objc dynamic var age: Int = 0
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataRegisteredModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var date: String?
  @objc dynamic var age: Int = 0
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataIDModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var name: String?
  @objc dynamic var value: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataPictureModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var large: String?
  @objc dynamic var medium: String?
  @objc dynamic var thumbnail: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

final class RandomUserDataModel: Object {
  @objc dynamic var id: String?
  @objc dynamic var gender: String?
  @objc dynamic var name: RandomUserDataNameModel?
  @objc dynamic var location: RandomUserDataLocationModel?
  @objc dynamic var email: String?
  @objc dynamic var login: RandomUserDataLoginModel?
  @objc dynamic var dob: RandomUserDataDOBModel?
  @objc dynamic var registered: RandomUserDataRegisteredModel?
  @objc dynamic var phone: String?
  @objc dynamic var cell: String?
  @objc dynamic var dataId: RandomUserDataIDModel?
  @objc dynamic var picture: RandomUserDataPictureModel?
  @objc dynamic var nat: String?
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(value: RandomUserData) {
    self.init()
    let objName = RandomUserDataNameModel()
    let objLocation = RandomUserDataLocationModel()
    let objLocationCoordinates = RandomUserDataLocationCoordinatesModel()
    let objLocationTimezone = RandomUserDataLocationTimezoneModel()
    let objLogin = RandomUserDataLoginModel()
    let objDOB = RandomUserDataDOBModel()
    let objRegistred = RandomUserDataRegisteredModel()
    let objDataId = RandomUserDataIDModel()
    let objPicture = RandomUserDataPictureModel()

    self.id = value.login?.uuid
    self.gender = value.gender
    objName.id = value.login?.uuid
    objName.first = value.name?.first
    objName.last = value.name?.last
    objName.title = value.name?.title
    self.name = objName
    objLocation.id = value.login?.uuid
    objLocation.street = value.location?.street
    objLocation.city = value.location?.city
    objLocation.state = value.location?.state
    objLocation.postcode = value.location?.postcode ?? 0
    objLocationCoordinates.id = value.login?.uuid
    objLocationCoordinates.latitude = value.location?.coordinates?.latitude
    objLocationCoordinates.longitude = value.location?.coordinates?.longitude
    objLocation.coordinates = objLocationCoordinates
    objLocationTimezone.id = value.login?.uuid
    objLocationTimezone.offset = value.location?.timezone?.offset
    objLocationTimezone.zoneDescription = value.location?.timezone?.description
    objLocation.timezone = objLocationTimezone
    self.location = objLocation
    self.email = value.email
    objLogin.uuid = value.login?.uuid
    objLogin.username = value.login?.username
    objLogin.password = value.login?.password
    objLogin.salt = value.login?.salt
    objLogin.md5 = value.login?.md5
    objLogin.sha1 = value.login?.sha1
    objLogin.sha256 = value.login?.sha256
    self.login = objLogin
    objDOB.id = value.login?.uuid
    objDOB.date = value.dob?.date
    objDOB.age = value.dob?.age ?? 0
    self.dob = objDOB
    objRegistred.id = value.login?.uuid
    objRegistred.date = value.registered?.date
    objRegistred.age = value.registered?.age ?? 0
    self.registered = objRegistred
    self.phone = value.phone
    self.cell = value.cell
    objDataId.id = value.login?.uuid
    objDataId.name = value.id?.name
    objDataId.value = value.id?.value
    self.dataId = objDataId
    objPicture.id = value.login?.uuid
    objPicture.large = value.picture?.large
    objPicture.medium = value.picture?.medium
    objPicture.thumbnail = value.picture?.thumbnail
    self.picture = objPicture
    self.nat = value.nat
  }
}

func writeRandomUserDataModel(data: RandomUserData) {
  DispatchQueue(label: "background").async {
    let realm = try! Realm()
    let obj = RandomUserDataModel(value: data)
    try! realm.write {
      realm.add(obj, update: true)
    }
  }
}
