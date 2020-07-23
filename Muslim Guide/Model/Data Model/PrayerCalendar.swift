//
//  Calendar.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/10/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import RealmSwift
//MARK: - PrayerCalendar
struct PrayerCalendar:Decodable
{
    //var status:String
    var data:[PrayerTimes]
}
//MARK: - PrayerTimes
struct PrayerTimes:Decodable
{
    var timings:Timings
    var date:PrayerDate
}
//MARK: - Timings
struct Timings:Decodable {

    var Fajr :String
    var Sunrise: String
    var Dhuhr: String
    var Asr: String
    var Sunset: String
    var Maghrib: String
    var Isha: String
    var Imsak: String
    var Midnight: String
}
//MARK: - PrayerDate
struct PrayerDate:Decodable {
    var timestamp:String
    var gregorian:Gregorian
}
//MARK: - Gregorian
struct Gregorian:Decodable
{
    var date:String
    var month:Month
    var year:String
}
//MARK: - Month
struct Month:Decodable {
    var number:Int
}
