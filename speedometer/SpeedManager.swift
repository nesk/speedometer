//
//  SpeedManager.swift
//  speedometer
//
//  Created by Johann Pardanaud on 29/09/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit
import CoreLocation

protocol SpeedManagerDelegate {
    func speedDidChange(speed: CLLocationSpeed)
}

class SpeedManager: NSObject, CLLocationManagerDelegate {

    let locationManager: CLLocationManager?
    var delegate: SpeedManagerDelegate?

    override init() {
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil

        super.init()

        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
                locationManager.requestAlwaysAuthorization()
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let kmph = locations[locations.count - 1].speed / 1000 * 3600;
            delegate?.speedDidChange(kmph);
        }
    }

}
