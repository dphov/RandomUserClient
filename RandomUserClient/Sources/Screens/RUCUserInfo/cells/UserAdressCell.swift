//
//  UserAdressCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 02/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserAdressCell: UITableViewCell {

  @IBOutlet weak var postcodeLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var streetLabel: UILabel!

  func setup(_ obj: RandomUserDataLocationModel) {
    if let userObjectLocationCity: String = obj.city,
      let userObjectLocationState: String = obj.state,
      let userObjectLocationStreet: String = obj.street {
        self.cityLabel.text = "City: " + userObjectLocationCity.capitalized
        self.postcodeLabel.text = "Postcode: " + String(obj.postcode)
        self.stateLabel.text = "State: " + userObjectLocationState.capitalized
        self.streetLabel.text = "Street: " + userObjectLocationStreet.capitalized
    }
  }
}
