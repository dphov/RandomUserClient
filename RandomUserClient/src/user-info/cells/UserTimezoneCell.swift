//
//  UserTimezoneCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 02/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserTimezoneCell: UITableViewCell {
  @IBOutlet weak var offsetLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  func setup (_ obj: RandomUserDataLocationTimezoneModel) {
    if let userObjectTimezoneOffset: String = obj.offset,
      let userObjectTimezoneDescription: String = obj.zoneDescription {
      self.offsetLabel.text = "Offset: " + userObjectTimezoneOffset
      self.descriptionLabel.text = "Description: " + userObjectTimezoneDescription
    }
  }
}
