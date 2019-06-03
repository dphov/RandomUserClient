//
//  UserInfoTableViewCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 28/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit

protocol UsersListTableViewCellDelegate: class {
  func callMe(_ cell: UsersListTableViewCell)
}

class UsersListTableViewCell: UITableViewCell {
    weak var delegate: UsersListTableViewCellDelegate?
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
  //TODO: write to db
    @IBAction func favouritesButtonPressed(_ sender: UIButton) {
          delegate?.callMe(self)
    }
}
