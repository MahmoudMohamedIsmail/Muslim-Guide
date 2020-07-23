//
//  PrayerTimesCalendar.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/16/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import RealmSwift
//MARK: - PrayerTimesCalendar
class PrayerTimesCalendar: Object {
  @objc dynamic var month = 0
  @objc dynamic var year = 0
   let prayerTimes=List<PrayerTimesDB>()
   var parentCity = LinkingObjects(fromType: City.self, property: "calendar")
}
