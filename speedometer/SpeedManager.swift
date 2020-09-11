//
//  SpeedManager.swift
//  speedometer
//
//  Created by Johann Pardanaud on 29/09/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import CoreLocation

typealias Speed = CLLocationSpeed

protocol SpeedManagerDelegate: AnyObject {
    func speedDidChange(speed: Speed)
}

class SpeedManager: NSObject, CLLocationManagerDelegate {

    weak var delegate: SpeedManagerDelegate?
    private let locationManager: CLLocationManager?

    override init() {
        locationManager = CLLocationManager.locationServicesEnabled() ? CLLocationManager() : nil

        super.init()

        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation

            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
                locationManager.requestAlwaysAuthorization()
            } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedAlways {
            locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            let kmph = max(locations[locations.count - 1].speed / 1000 * 3600, 0)
            delegate?.speedDidChange(speed: kmph)
        }
    }
}
