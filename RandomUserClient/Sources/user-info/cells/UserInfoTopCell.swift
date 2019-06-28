//
//  UserInfoTopCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UserInfoTopCell: UITableViewCell {
  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!

  func setup(_ obj: RandomUserDataModel) {
    guard let userObjectPictureLarge = obj.picture?.large else {return}
    guard let url = URL(string: (userObjectPictureLarge)) else {return}
    var data: Data = Data()
    if InternetReachiability.isConnectedToNetwork() {
      DispatchQueue.global().async {
        do {
          data = try Data(contentsOf: url)
        } catch {
          print(error.localizedDescription)
        }
        DispatchQueue.main.async {
          self.userAvatarImageView.image = UIImage(data: data)
        }
      }
    }
    self.firstNameLabel.text = obj.name?.first?.capitalized
    self.lastNameLabel.text = obj.name?.last?.capitalized
  }
}
