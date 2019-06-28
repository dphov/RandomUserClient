//
//  UserOtherDataCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 02/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserOtherDataCell: UITableViewCell {

  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var cellLabel: UILabel!
  @IBOutlet weak var natLabel: UILabel!

  func setup(_ obj: RandomUserDataModel) {
    if let userObjectCell = obj.cell,
      let userObjectPhone  = obj.phone,
      let userObjectEmail = obj.email,
      let userObjectNat = obj.nat,
      let userObjectGender = obj.gender {
        self.cellLabel.text = "Cell: " + userObjectCell
        self.phoneLabel.text = "Phone: " + userObjectPhone
        self.emailLabel.text = "E-mail: " + userObjectEmail
        self.natLabel.text = "Nationality: " + userObjectNat
        self.genderLabel.text = "Gender: " + userObjectGender
    }
  }
}
