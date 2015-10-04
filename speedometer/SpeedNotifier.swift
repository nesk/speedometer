//
//  SpeedNotifier.swift
//  speedometer
//
//  Created by Johann Pardanaud on 05/10/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit

class SpeedNotifier: NSObject, SpeedManagerDelegate {

    static private let sharedInstance = SpeedNotifier()

    var shouldNotify = false
    var notificationsInterval: NSTimeInterval = 7

    private let speedManager = SpeedManager()
    private var lastNotificationTime: NSDate? = nil

    static func sharedNotifier() -> SpeedNotifier {
        return sharedInstance
    }

    private override init() {
        super.init()

        speedManager.delegate = self

        let notificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }

    func clearNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }

    func speedDidChange(speed: Speed) {
        let canNotify = (lastNotificationTime == nil || lastNotificationTime?.timeIntervalSinceNow <= -7)
                        && shouldNotify

        if canNotify {
            let notification = UILocalNotification()
            notification.alertBody = "\(Int(speed)) km/h"

            clearNotifications()
            UIApplication.sharedApplication().scheduleLocalNotification(notification)

            lastNotificationTime = NSDate()
        }
    }

}
