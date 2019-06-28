//
//  UserDateAgeDisplayCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 02/06/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserDateAgeDisplayCell: UITableViewCell {
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!

  func setup(_ obj: RandomUserDataDOBModel) {
    if let userObjectDOBDate = obj.date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      if let date = dateFormatter.date(from: userObjectDOBDate) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.dateLabel.text = "Date: " +
          dateFormatter.string(from: date)
      }
      self.headerLabel.text = "Date of birth"
      self.ageLabel.text = "Age: " + String(obj.age)
    }
  }
  func setup(_ obj: RandomUserDataRegisteredModel) {
    if let userObjectRegisteredDate = obj.date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      if let date = dateFormatter.date(from: userObjectRegisteredDate) {
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.dateLabel.text = "Date: " + dateFormatter.string(from: date)
      }
      self.headerLabel.text = "Date of registration"
      self.ageLabel.text = "Age: " + String(obj.age)
    }
  }
}
