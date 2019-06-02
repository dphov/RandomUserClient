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
}
