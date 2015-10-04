//
//  ViewController.swift
//  speedometer
//
//  Created by Johann Pardanaud on 29/09/2015.
//  Copyright © 2015 Johann Pardanaud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeedManagerDelegate {

    @IBOutlet weak var speedLabel: UILabel?

    let speedManager = SpeedManager()

    override func viewDidLoad() {
        speedManager.delegate = self
        super.viewDidLoad()
    }

    @IBAction func toggleNotifications(sender: UISwitch) {
        SpeedNotifier.sharedNotifier().shouldNotify = sender.on
    }

    func speedDidChange(speed: Speed) {
        speedLabel?.text = String(Int(speed))
    }

}

