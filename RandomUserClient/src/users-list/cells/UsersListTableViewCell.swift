//
//  UserInfoTableViewCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

protocol UsersListTableViewCellDelegate: class {
  func changeInFavoritesStatus(_ cell: UsersListTableViewCell)
}

class UsersListTableViewCell: UITableViewCell {
    weak var delegate: UsersListTableViewCellDelegate?
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBAction func favouritesButtonPressed(_ sender: UIButton) {
          delegate?.changeInFavoritesStatus(self)
    }
}
