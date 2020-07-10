//
//  BeaconManager.swift
//  Beacon Test
//
//  Created by Juan Colilla on 11/12/2019.
//  Copyright © 2019 Juan Colilla. All rights reserved.
//

import Foundation
import CoreLocation

/**
Clase responsable de la interacción entre la aplicación y los servicios nativos de localización e interacción con balizas bluetooth. Basada en las APIs "CoreLocation" y "UserNotifications".

Se puede instanciar sin necesidad de ningún parámetro de entrada.

*/

class BeaconManager {
    
    let locationManager: CLLocationManager = CLLocationManager()
    var region = CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: UUID(uuidString: /*"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"*/"B9407F30-F5F8-466E-AFF9-25556B57FE6D")!), identifier: "Test Beacons")
    
    init() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /// Desencadena el proceso requerido para la autorización por parte del usuario (en caso de no tenerla) para hacer uso de su ubicación.
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
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!))
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
