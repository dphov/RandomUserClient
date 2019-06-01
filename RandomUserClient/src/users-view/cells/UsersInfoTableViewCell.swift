//
//  UserInfoTableViewCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

class UsersInfoTableViewCell: UITableViewCell {
    var inFavourites = false
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
  //TODO: write to db
    @IBAction func favouritesButtonPressed(_ sender: UIButton) {
        if inFavourites {
          print("Delete from fav!")
          self.favouritesButton.setImage(UIImage(named: "star"), for: .normal)
        } else {
          print("Add to fav!")
          self.favouritesButton.setImage(UIImage(named: "star-filled"), for: .normal)
        }
        inFavourites = !inFavourites
    }
}
