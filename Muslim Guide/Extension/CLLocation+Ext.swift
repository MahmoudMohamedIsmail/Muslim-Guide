//
//  CLLocation+Ext.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/26/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import SwiftUI
import CoreLocation
extension CLLocation {
  func bearingToLocationRadian(_ destinationLocation: CLLocation) -> CGFloat {
    
    let lat1 = self.coordinate.latitude.degreesToRadians
    let lon1 = self.coordinate.longitude.degreesToRadians
    
    let lat2 = destinationLocation.coordinate.latitude.degreesToRadians
    let lon2 = destinationLocation.coordinate.longitude.degreesToRadians
    
    let dLon = lon2 - lon1
    
    let y = sin(dLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
    let radiansBearing = atan2(y, x)
    
    return CGFloat(radiansBearing)
  }
  
  func bearingToLocationDegrees(destinationLocation: CLLocation) -> CGFloat {
    return bearingToLocationRadian(destinationLocation).radiansToDegrees
  }
}
//MARK: - Add two properties to CLLocationDegrees
extension CLLocationDegrees{
    var degreesToRadians: CLLocationDegrees { return self * .pi / 180 }
    var radiansToDegrees: CLLocationDegrees { return self * 180 / .pi }
}
