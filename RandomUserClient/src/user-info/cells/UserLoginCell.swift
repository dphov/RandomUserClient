//
//  UserLoginCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 02/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserLoginCell: UITableViewCell {
  @IBOutlet weak var uuidLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var saltLabel: UILabel!
  @IBOutlet weak var md5Label: UILabel!
  @IBOutlet weak var sha1Label: UILabel!
  @IBOutlet weak var sha256Label: UILabel!
  func setup(_ obj: RandomUserDataLoginModel) {
    if let userObjectLoginMD5 = obj.md5,
      let userObjectLoginSalt = obj.salt,
      let userObjectLoginSHA1 = obj.sha1,
      let userObjectLoginSHA256 = obj.sha256,
      let userObjectLoginUsername = obj.username,
      let userObjectLoginPassword = obj.password,
      let userObjectLoginUUID = obj.uuid {
        self.md5Label.text = "MD5: " + userObjectLoginMD5
        self.passwordLabel.text = "Password: " + userObjectLoginPassword
        self.saltLabel.text = "Salt: " + userObjectLoginSalt
        self.sha1Label.text = "SHA1: " + userObjectLoginSHA1
        self.sha256Label.text = "SHA256: " + userObjectLoginSHA256
        self.usernameLabel.text = "Username: " + userObjectLoginUsername
        self.uuidLabel.text = "UUID: " + userObjectLoginUUID
      }
  }
}
