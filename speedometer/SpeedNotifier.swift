//
//  SpeedNotifier.swift
//  speedometer
//
//  Created by Johann Pardanaud on 05/10/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit

protocol SpeedNotifierDelegate: AnyObject {
    func notificationsStatusDidChange(shouldNotify: Bool)
}

class SpeedNotifier: NSObject, SpeedManagerDelegate {

    private static let sharedInstance = SpeedNotifier()

    weak var delegate: SpeedNotifierDelegate?
    var notificationsInterval: TimeInterval = 7

    var shouldNotify = false {
        didSet {
            notificationsStatusDidChange()
        }
    }

    private let speedManager = SpeedManager()
    private var lastNotificationTime: Date?

    private let shortcuts = [
        "enable": UIApplicationShortcutItem(
            type: "speed.notifications.enable",
            localizedTitle: "Me notifier",
            localizedSubtitle: "Active les notifications",
            icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIcon.IconType.location),
            userInfo: nil
        ),

        "disable": UIApplicationShortcutItem(
            type: "speed.notifications.disable",
            localizedTitle: "Ne plus me notifier",
            localizedSubtitle: "Désactive les notifications",
            icon: UIApplicationShortcutIcon(type: UIApplicationShortcutIcon.IconType.pause),
            userInfo: nil
        )
    ]

    static func sharedNotifier() -> SpeedNotifier {
        sharedInstance
    }

    override private init() {
        super.init()

        speedManager.delegate = self

        let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)

        notificationsStatusDidChange()
    }

    func clearNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func speedDidChange(speed: Speed) {
        let canNotify = (lastNotificationTime == nil || lastNotificationTime!.timeIntervalSinceNow <= Double(-7))
            && shouldNotify

        if canNotify {
            let notification = UILocalNotification()
            notification.alertBody = "\(Int(speed)) km/h"

            clearNotifications()
            UIApplication.shared.scheduleLocalNotification(notification)

            lastNotificationTime = Date()
        }
    }

    private func notificationsStatusDidChange() {
        let shortcutKey = shouldNotify ? "disable" : "enable"

        if let shortcut = shortcuts[shortcutKey] {
            UIApplication.shared.shortcutItems = [shortcut]
        }

        delegate?.notificationsStatusDidChange(shouldNotify: shouldNotify)
    }

}
