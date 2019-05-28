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
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    func getId() -> String {
        return "UserInfoTopCell"
    }
}
