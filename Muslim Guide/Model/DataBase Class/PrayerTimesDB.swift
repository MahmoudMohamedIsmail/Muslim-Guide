//
//  PrayerTimesDB.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/22/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import RealmSwift
class PrayerTimesDB: Object {
   
 @objc dynamic var Fajr = ""
    @objc dynamic var Sunrise = ""
    @objc dynamic var Dhuhr = ""
    @objc dynamic var Asr = ""
    @objc dynamic var Sunset = ""
    @objc dynamic var Maghrib = ""
    @objc dynamic var Isha = ""
    @objc dynamic var Imsak = ""
    @objc dynamic var Midnight = ""
}
