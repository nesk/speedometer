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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
        SpeedNotifier.sharedNotifier().shouldNotify = shortcutItem.type == "speed.notifications.enable"
    }

    func applicationDidBecomeActive(application: UIApplication) {
        SpeedNotifier.sharedNotifier().clearNotifications()
    }

}

