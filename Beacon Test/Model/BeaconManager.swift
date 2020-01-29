//
//  BeaconManager.swift
//  Beacon Test
//
//  Created by Juan Colilla on 11/12/2019.
//  Copyright © 2019 Juan Colilla. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager {
    
    let locationManager: CLLocationManager = CLLocationManager()
    var region = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!), identifier: "Test Beacons")
    
    init() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func checkUserPermissions() {
        
        switch (CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            break;
        case .denied, .restricted:
            break;
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break;
        default:
            break;
        }
    }
    
    func setDelegate(delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
    }
    
    func setRegion() {
        locationManager.startMonitoring(for: region)
        region.notifyOnEntry = true
        region.notifyOnExit = true
    }
    func scanForBeacons(){
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!))
    }
    
    
    func filterUnknownBeacons(beacons: [CLBeacon]) -> [CLBeacon]  {
        let beaconsFiltered = beacons.filter { (beacon: CLBeacon) -> Bool in
            return (beacon.proximity != .unknown)
        }
        return beaconsFiltered
    }
    
//    func translateRSSItoMeters(beacon: CLBeacon) -> String {
//
//        switch(beacon.rssi+beacon.rssi*2)
//        {
//        case 0..
//
//
//        }
//
//
//
//    }
    
}
