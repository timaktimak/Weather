//
//  LocationManager.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
    func locationManagerDidGetRegionName(region: String)
}

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    private let locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?
    
    func getInfo() {
        if NSUserDefaults.standardUserDefaults().boolForKey(Constants.LocationDetectedIdentifier) { return }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        } else {
            print("Location services not enabled")
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if let placemark = placemarks?.first {
                self.placemarkFound(placemark)
            }
        })
    }
    
    func placemarkFound(placemark: CLPlacemark?) {
        guard let placemark = placemark, let locality = placemark.locality else { return }
        delegate?.locationManagerDidGetRegionName(locality)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
}
