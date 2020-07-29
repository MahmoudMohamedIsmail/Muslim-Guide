//
//  TimeManger.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/15/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation

class TimeManager {
    
    //MARK: - Calculate remaining time
    static func getRemainingTime(prayerTime:String) -> RemainingTime {
        
        let convertedPrayerTime = TimeManager.convertTimeFormatTo_24(time: prayerTime)
        
        let now = "\(TimeManager.getHourNumber()):\(TimeManager.getMinuteNumber())"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let prayerDate = formatter.date(from: convertedPrayerTime)!
        let nowDate = formatter.date(from: now)!
        
        let elapsedTime = prayerDate.timeIntervalSince(nowDate)
        
        // convert from seconds to hours, rounding down to the nearest hour
        let hours = floor(elapsedTime / 60 / 60)
        
        // we have to subtract the number of seconds in hours from minutes to get
        // the remaining minutes, rounding down to the nearest minute (in case you
        // want to get seconds down the road)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        
        return RemainingTime(hour: Int(hours),minute: Int(minutes))
    }
    
    //MARK: - Converting time
      //24 to AM,PM    EX: 13:23 To 1:23 PM
      static func convertTimeFormatTo_12_AM(time:String) -> String {
          
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "HH:mm"
          
          let date = dateFormatter.date(from: time)
          
          dateFormatter.dateFormat = "h:mm a"
          let newDate = dateFormatter.string(from: date!)
          
          return newDate
      }
      static func convertTimeFormatTo_24(time:String) -> String {
          
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "h:mm a"
        
          let date = dateFormatter.date(from: time)
          
          dateFormatter.dateFormat = "HH:mm"
          let newDate = dateFormatter.string(from: date!)
          
          return newDate
      }
    //MARK: - Calendar methods
    static func getMinuteNumber() -> Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: Date())
    }
    static func getHourNumber() -> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: Date())
    }
    static func getDayNumber() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: Date())
    }
    static func getMonthNumber() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: Date())
    }
    static func getYearNumber() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }
  
    
}
