//
//  SpeedNotifier.swift
//  speedometer
//
//  Created by Johann Pardanaud on 05/10/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit

protocol SpeedNotifierDelegate {
    func notificationsStatusDidChange(shouldNotify: Bool)
}

class SpeedNotifier: NSObject, SpeedManagerDelegate {

    static private let sharedInstance = SpeedNotifier()

    var delegate: SpeedNotifierDelegate?
    var notificationsInterval: NSTimeInterval = 7

    var shouldNotify = false {
        didSet {
            notificationsStatusDidChange()
        }
    }

    private let speedManager = SpeedManager()
    private var lastNotificationTime: NSDate? = nil

    private let shortcuts = [
        "enable": UIApplicationShortcutItem(
            type: "speed.notifications.enable",
            localizedTitle: "Me notifier",
            localizedSubtitle: "Active les notifications",
            icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Location),
            userInfo: nil
        ),

        "disable": UIApplicationShortcutItem(
            type: "speed.notifications.disable",
            localizedTitle: "Ne plus me notifier",
            localizedSubtitle: "Désactive les notifications",
            icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIconType.Pause),
            userInfo: nil
        )
    ]

    static func sharedNotifier() -> SpeedNotifier {
        return sharedInstance
    }

    private override init() {
        super.init()

        speedManager.delegate = self

        let notificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        notificationsStatusDidChange()
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

    private func notificationsStatusDidChange() {
        let shortcutKey = shouldNotify ? "disable" : "enable"

        if let shortcut = shortcuts[shortcutKey] {
            UIApplication.sharedApplication().shortcutItems = [shortcut]
        }

        delegate?.notificationsStatusDidChange(shouldNotify)
    }

}
