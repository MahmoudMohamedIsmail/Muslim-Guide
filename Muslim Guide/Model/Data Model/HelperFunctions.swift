//
//  HelperFunctions.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/15/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation

class HelperFunctions {
    //MARK: - Methods
    //erase BST from string like "02:52 (BST)" to be "02:52"
    //Data from the server like this (Fajr: "02:52 (BST)", Sunrise: "04:43 (BST)", Dhuhr: "13:01 (BST)", Asr: "17:23 (BST)", Sunset: "21:19 (BST)")
    static func eraseBST(calendar:PrayerCalendar) -> PrayerCalendar {
        
        var newCalendar = PrayerCalendar(data: [PrayerTimes]())
        for timings in calendar.data
        {
            // erase and convert time format to AM and PM
            let Fajr =  TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Fajr.components(separatedBy: " ")[0])
            let Sunrise = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Sunrise.components(separatedBy: " ")[0])
            let Dhuhr = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Dhuhr.components(separatedBy: " ")[0])
            let Asr = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Asr.components(separatedBy: " ")[0])
            let Sunset = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Sunset.components(separatedBy: " ")[0])
            let Maghrib = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Maghrib.components(separatedBy: " ")[0])
            let Isha = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Isha.components(separatedBy: " ")[0])
            let Imsak = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Imsak.components(separatedBy: " ")[0])
            let Midnight = TimeManager.convertTimeFormatTo_12_AM(time: timings.timings.Midnight.components(separatedBy: " ")[0])
            
            let newTimings = Timings(Fajr: Fajr, Sunrise: Sunrise, Dhuhr: Dhuhr, Asr: Asr, Sunset: Sunset, Maghrib: Maghrib, Isha: Isha, Imsak: Imsak, Midnight: Midnight)
            
            newCalendar.data.append(PrayerTimes(timings: newTimings, date: timings.date))
        }
        return newCalendar
    }
    
    //cast Timings calss to PrayerTimesDB class
    static func castingData(from timings:Timings) -> PrayerTimesDB {
        
        let prayerTimesDB = PrayerTimesDB()
        prayerTimesDB.Asr=timings.Asr
        prayerTimesDB.Dhuhr=timings.Dhuhr
        prayerTimesDB.Fajr=timings.Fajr
        prayerTimesDB.Imsak=timings.Imsak
        prayerTimesDB.Isha=timings.Isha
        prayerTimesDB.Maghrib=timings.Maghrib
        prayerTimesDB.Midnight=timings.Midnight
        prayerTimesDB.Sunset=timings.Sunset
        prayerTimesDB.Sunrise=timings.Sunrise
        
        return prayerTimesDB
    }
    static func getPrayerTime(prayerName:String, prayerTimes:PrayerTimesDB) -> String
    {
        var prayerTime = ""
        
        if (prayerName=="Fajr") {
            prayerTime = prayerTimes.Fajr
        }
        else if (prayerName=="Sunrise")
        {
            prayerTime = prayerTimes.Sunrise
        }
        else if (prayerName=="Dhuhr")
        {
            prayerTime = prayerTimes.Dhuhr
        }
        else if (prayerName=="Asr")
        {
            prayerTime = prayerTimes.Asr
        }
        else if (prayerName=="Maghrib")
        {
            prayerTime = prayerTimes.Maghrib
        }
        else if (prayerName=="Isha")
        {
            prayerTime = prayerTimes.Isha
        }
        
        return prayerTime
    }
}
