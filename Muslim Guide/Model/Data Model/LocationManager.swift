//
//  LocationManger.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/26/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit
import CoreLocation
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    //MARK: - Properties
    var locationCallback: ((CLLocation) -> ())? = nil
    var headingCallback: ((CLLocationDirection) -> ())? = nil
    fileprivate  let locationManager=CLLocationManager()
  //MARK: - Initialize
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        startTrackingLocationAndHeading()
    }
    //MARK: - Methods
    func startTrackingLocationAndHeading(){
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    func stopTrackingLocationAndHeading(){
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // latestLocation = locations.last
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // latestHeading = CGFloat(newHeading.trueHeading)
        headingCallback?(newHeading.trueHeading)
       
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Error while updating location " + error.localizedDescription)
    }
    
}
