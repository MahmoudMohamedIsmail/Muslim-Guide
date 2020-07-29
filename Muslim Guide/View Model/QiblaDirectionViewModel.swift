//
//  QiblaDirectionViewModel.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/28/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI
class QiblaDirectionViewModel:ObservableObject {
    //MARK: - Properties
    @ObservedObject private var locationManager:LocationManager
   @Published var angel:CGFloat
        {
        didSet{
            trueDirection = ((self.angel > 0 || self.angel > 359) && self.angel < 1) ? true:false
        }
    }

  @Published var trueDirection:Bool
    
    var latestBearing:CGFloat=0
    {
        didSet
        {
            self.angel = (latestBearing.radiansToDegrees - latestHeading) < 0 ?
                   ((latestBearing.radiansToDegrees - latestHeading) +  (360)) :
                   (latestBearing.radiansToDegrees - latestHeading)
        }
    }
    var latestHeading:CGFloat=0
    {
        didSet
        {
            self.angel = (latestBearing.radiansToDegrees - latestHeading) < 0 ?
            ((latestBearing.radiansToDegrees - latestHeading) +  (360)) :
            (latestBearing.radiansToDegrees - latestHeading)

        }
        
    }
    //MARK: - Initialize
     init() {
        self.locationManager = LocationManager()
        self.angel = 0
        self.trueDirection = false
       trackLocationAndHeading()
    }
   //MARK: - Methods
    func trackLocationAndHeading()  {
        locationManager.locationCallback = { location in
            self.latestBearing = location.bearingToLocationRadian(CLLocation(latitude: 21.4225, longitude: 39.8262))
        }
        
        locationManager.headingCallback = { newHeading in
            self.latestHeading =  CGFloat(newHeading)
        }
    }
}
