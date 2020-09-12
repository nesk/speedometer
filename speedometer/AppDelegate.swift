//
//  AppDelegate.swift
//  speedometer
//
//  Created by Johann Pardanaud on 29/09/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        SpeedNotifier.sharedNotifier().shouldNotify = shortcutItem.type == "speed.notifications.enable"
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SpeedNotifier.sharedNotifier().clearNotifications()

    }
}
