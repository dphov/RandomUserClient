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

  func setup(_ obj: RandomUserDataLocationModel) {
    if let userObjectLocationCoordinates = obj.coordinates,
      let userObjectLocationCoordinatesLatitude = userObjectLocationCoordinates.latitude,
      let userObjectLocationCoordinatesLongitude = userObjectLocationCoordinates.longitude {
      self.userLocationMapView.mapType = .standard
      self.userLocationMapView.setRegion(MKCoordinateRegion.init(center:
          CLLocationCoordinate2D(
            latitude: userObjectLocationCoordinatesLatitude.doubleValue,
            longitude: userObjectLocationCoordinatesLongitude.doubleValue),
        latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
    }
  }
}
