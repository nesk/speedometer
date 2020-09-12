//
//  ViewController.swift
//  speedometer
//
//  Created by Johann Pardanaud on 29/09/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeedNotifierDelegate, SpeedManagerDelegate {

    @IBOutlet private weak var speedLabel: UILabel?
    @IBOutlet private weak var notificationsSwitch: UISwitch?

    let speedManager = SpeedManager()

    override func viewDidLoad() {
        speedManager.delegate = self
        SpeedNotifier.sharedNotifier().delegate = self
        super.viewDidLoad()
    }

    @IBAction private func toggleNotifications(sender: UISwitch) {
        SpeedNotifier.sharedNotifier().shouldNotify = sender.isOn
    }

    func notificationsStatusDidChange(shouldNotify: Bool) {
        notificationsSwitch?.isOn = shouldNotify
    }

    func speedDidChange(speed: Speed) {
        speedLabel?.text = String(Int(speed))
    }

}
