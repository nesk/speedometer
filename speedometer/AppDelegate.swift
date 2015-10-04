//
//  AppDelegate.swift
//  speedometer
//
//  Created by Johann Pardanaud on 29/09/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SpeedManagerDelegate {

    var window: UIWindow?

    let speedManager = SpeedManager()
    var lastNotificationTime: NSDate? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        speedManager.delegate = self

        let notificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    func speedDidChange(speed: CLLocationSpeed) {
        let canNotify = lastNotificationTime == nil || lastNotificationTime?.timeIntervalSinceNow <= -7

        if canNotify {
            let notification = UILocalNotification()
            notification.alertBody = "\(Int(speed)) km/h"

            let application = UIApplication.sharedApplication()
            application.cancelAllLocalNotifications()
            application.scheduleLocalNotification(notification)

            lastNotificationTime = NSDate()
        }
    }

}

