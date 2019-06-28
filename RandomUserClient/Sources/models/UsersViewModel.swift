//
//  UsersViewModel.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 30/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import RealmSwift

@objcMembers final class RandomUserDataNameModel: Object {
  dynamic var id: String?
  dynamic var title: String?
  dynamic var first: String?
  dynamic var last: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataLocationCoordinatesModel: Object {
  dynamic var id: String?
  dynamic var latitude: String?
  dynamic var longitude: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataLocationTimezoneModel: Object {
  dynamic var id: String?
  dynamic var offset: String?
  dynamic var zoneDescription: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataLocationModel: Object {
  dynamic var id: String?
  dynamic var street: String?
  dynamic var city: String?
  dynamic var state: String?
  dynamic var postcode: Int = 0
  dynamic var coordinates: RandomUserDataLocationCoordinatesModel?
  dynamic var timezone: RandomUserDataLocationTimezoneModel?
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataLoginModel: Object {
  dynamic var uuid: String?
  dynamic var username: String?
  dynamic var password: String?
  dynamic var salt: String?
  dynamic var md5: String?
  dynamic var sha1: String?
  dynamic var sha256: String?
  override static func primaryKey() -> String? {
    return "uuid"
  }
}

@objcMembers final class RandomUserDataDOBModel: Object {
  dynamic var id: String?
  dynamic var date: String?
  dynamic var age: Int = 0
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataRegisteredModel: Object {
  dynamic var id: String?
  dynamic var date: String?
  dynamic var age: Int = 0
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataIDModel: Object {
  dynamic var id: String?
  dynamic var name: String?
  dynamic var value: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataPictureModel: Object {
  dynamic var id: String?
  dynamic var large: String?
  dynamic var medium: String?
  dynamic var thumbnail: String?
  override static func primaryKey() -> String? {
    return "id"
  }
}

@objcMembers final class RandomUserDataModel: Object {
  dynamic var id: String?
  dynamic var gender: String?
  dynamic var name: RandomUserDataNameModel?
  dynamic var location: RandomUserDataLocationModel?
  dynamic var email: String?
  dynamic var login: RandomUserDataLoginModel?
  dynamic var dob: RandomUserDataDOBModel?
  dynamic var registered: RandomUserDataRegisteredModel?
  dynamic var phone: String?
  dynamic var cell: String?
  dynamic var dataId: RandomUserDataIDModel?
  dynamic var picture: RandomUserDataPictureModel?
  dynamic var nat: String?
  dynamic var isInFavorites: String = "false"

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
