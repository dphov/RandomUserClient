//
//  UserLocationCell.swift
//  RandomUserClient
//
//  Created by Dmitry Petukhov on 31/05/2019.
//  Copyright © 2019 Dmitry Petukhov. All rights reserved.
//

import UIKit
import MapKit

class UserLocationCell: UITableViewCell, MKMapViewDelegate {
  override func layoutSubviews() {
    self.userLocationMapView.delegate = self
  }
  @IBOutlet weak var userLocationMapView: MKMapView!
}
