//
//  UserIDCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 02/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserIDCell: UITableViewCell {
  @IBOutlet weak var typeOfIdLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!

  func setup(_ obj: RandomUserDataIDModel) {
    if let userObjectIDName = obj.name,
      let userObjectIDValue = obj.value {
      self.typeOfIdLabel.text = "Type of ID: " + userObjectIDName
      self.valueLabel.text = "Value: " + userObjectIDValue
    }
  }
}
