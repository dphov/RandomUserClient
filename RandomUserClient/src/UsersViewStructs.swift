//
//  UsersViewStructs.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 29/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import Foundation

struct RawServerResponse {
  enum RootKeys: String, CodingKey {
    case gender
    case name
    case location
    case email
    case login
    case dob
    case registered
    case phone
    case cell
    case id
    case picture
    case nat
  }
  enum NameKeys: String, CodingKey {
    case title
    case first
    case last
  }
  enum CoordinatesKeys: String, CodingKey {
    case latitude
    case longitude
  }
  enum TimezoneKeys: String, CodingKey {
    case offset
    case description
  }
  enum LocationKeys: String, CodingKey {
    case street
    case city
    case state
    case postcode
    case coordinates
    case timezone
  }
  enum LoginKeys: String, CodingKey {
    case uuid
    case username
    case password
    case salt
    case md5
    case sha1
    case sha256
  }
  enum DOBKeys: String, CodingKey {
    case date
    case age
  }
  enum RegisteredKeys: String, CodingKey {
    case date
    case age
  }
  enum RandomUserDataID: String, CodingKey {
    case name
    case value
  }
  enum RandomUserDataPicture: String, CodingKey {
    case large
    case medium
    case thumbnail
  }
}

struct RandomUserDataName: Codable {
  let title: String?
  let first: String?
  let last: String?
}

struct RandomUserDataLocationCoordinates: Codable {
  let latitude: String?
  let longitude: String?
}

struct RandomUserDataLocationTimezone: Codable {
  let offset: String?
  let description: String?
}

struct RandomUserDataLocation: Codable {
  let street: String?
  let city: String?
  let state: String?
  let postcode: Int?
  let coordinates: RandomUserDataLocationCoordinates?
  let timezone: RandomUserDataLocationTimezone?
}

struct RandomUserDataLogin: Codable {
  let uuid: String?
  let username: String?
  let password: String?
  let salt: String?
  let md5: String?
  let sha1: String?
  let sha256: String?
}

struct RandomUserDataDOB: Codable {
  let date: String?
  let age: Int?
}

struct RandomUserDataRegistered: Codable {
  let date: String?
  let age: Int?
}

struct RandomUserDataID: Codable {
  let name: String?
  let value: String?
}

struct RandomUserDataPicture: Codable {
  let large: String?
  let medium: String?
  let thumbnail: String?
}

struct RandomUserData: Codable {
  let gender: String?
  let name: RandomUserDataName?
  let location: RandomUserDataLocation?
  let email: String?
  let login: RandomUserDataLogin?
  let dob: RandomUserDataDOB?
  let registered: RandomUserDataRegistered?
  let phone: String?
  let cell: String?
  let id: RandomUserDataID?
  let picture: RandomUserDataPicture?
  let nat: String?

  init(from decoder: Decoder) throws {
    let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
    self.gender = try? valueContainer.decode(String.self, forKey: CodingKeys.gender)
    self.name = try? valueContainer.decode(RandomUserDataName.self, forKey: CodingKeys.name)
    self.location = try? valueContainer.decode(RandomUserDataLocation.self, forKey: CodingKeys.location)
    self.email = try? valueContainer.decode(String.self, forKey: CodingKeys.email)
    self.login = try? valueContainer.decode(RandomUserDataLogin.self, forKey: CodingKeys.login)
    self.dob = try? valueContainer.decode(RandomUserDataDOB.self, forKey: CodingKeys.dob)
    self.registered = try? valueContainer.decode(RandomUserDataRegistered.self, forKey: CodingKeys.registered)
    self.phone = try? valueContainer.decode(String.self, forKey: CodingKeys.phone)
    self.cell = try? valueContainer.decode(String.self, forKey: CodingKeys.cell)
    self.id = try? valueContainer.decode(RandomUserDataID.self, forKey: CodingKeys.id)
    self.picture = try? valueContainer.decode(RandomUserDataPicture.self, forKey: CodingKeys.picture)
    self.nat = try? valueContainer.decode(String.self, forKey: CodingKeys.nat)
  }
}

struct Info: Codable {
  let seed: String?
  let results, page: Int?
  let version: String?
}

struct RandomUsersDataRoot: Codable {
  let results: [RandomUserData]?
  let info: Info?
}
