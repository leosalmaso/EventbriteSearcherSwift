//
//  LocationManager.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationManagerStatus: Int {
    case Authorized
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

class LocationManager: NSObject {

    static let sharedInstance = LocationManager()
    
    static let locationAuthorizationChanged = "location_changed"
    
    let locationManager = CLLocationManager()
    var tracking = false
    var lastUpdate: NSDate?
    var lastCoordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
        //Configure location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager.distanceFilter = 25;
        locationManager.delegate = self
    }
    
    func validatePermission() -> LocationManagerStatus {
        let status = CLLocationManager.authorizationStatus()
        
        if  status == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return .AuthorizationNotDetermined
        } else if status == .Denied || status == .Restricted {
            return .AuthorizationDenied
        } else {
            return .Authorized
        }
    }
    
    func startStandardTracking() {
        if (validatePermission() == .Authorized) {
            locationManager.startUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        let status = CLLocationManager.authorizationStatus()
        tracking = status != .Denied && status != .Restricted
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        tracking = false
    }
    
    func updateLocationInBackground(coordinate: CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            if let lastUpdate = lastUpdate {
                if lastUpdate.timeIntervalSinceNow > -10 {
                    return
                }
            }
            
            lastUpdate = NSDate()
            lastCoordinate = coordinate
            
            print("%f %f", coordinate.latitude, coordinate.longitude)
        }
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if (status != .Denied && status != .Restricted) {
            if (tracking) {
                startStandardTracking()
            }
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.updateLocationInBackground(locations.last?.coordinate)
    }
}
