//
//  City.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/16/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import RealmSwift
//MARK: - City
class City: Object {
    @objc dynamic var name = ""
   // @objc dynamic var location:Coordinate? = nil
    @objc dynamic var method = 3
    let calendar = List<PrayerTimesCalendar>()
}
