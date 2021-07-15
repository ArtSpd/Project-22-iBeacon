//
//  ViewController.swift
//  Project 22 iBeacon
//
//  Created by Артем Волков on 14.07.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.gray
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        let uuid = UUID(uuidString: "E4B5162B-6FE1-4426-98D0-869E1A67B2C1")!
        let constraint = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegions = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegions)
        locationManager?.startRangingBeacons(satisfying: constraint)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"

            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
                update(distance: beacon.proximity)
            print("123")
            } else {
                update(distance: .unknown)
                print("321")
            }
    }

}

