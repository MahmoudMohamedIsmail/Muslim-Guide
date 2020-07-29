//
//  NotificationManger.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/23/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager
{
    //MARK: - Methods
    
    static func requestPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (success, error) in
            let defaults = UserDefaults.standard
            if success{
                defaults.set(true, forKey:Constants.userPermissionEnabled)
            }else if let error = error {
                
                defaults.set(false, forKey:Constants.userPermissionEnabled)
                print(error.localizedDescription)
            }
        }
    }
    
    static func scheduleNotifications(For prayerTimes: PrayerTimesDB,_ alarmState:AlarmState) {
    
        let defaults = UserDefaults.standard
        let userPermissionEnabled = defaults.bool(forKey: Constants.userPermissionEnabled)
        
        if userPermissionEnabled
        {
            
            //Remove all notifications
            removeAllNotifications()
            
            //Fajr prayer
            if alarmState.Fajr
            {
                setNotification(Constants.prayers[0], getDateComponent(For: prayerTimes.Fajr))
            }
            
            //Dhuhr prayer
            if alarmState.Dhuhr
            {
                setNotification(Constants.prayers[1], getDateComponent(For: prayerTimes.Dhuhr))
            }
            //Asr prayer
            if alarmState.Asr
            {
                setNotification(Constants.prayers[2], getDateComponent(For: prayerTimes.Asr))
            }
            //Maghrib prayer
            if alarmState.Maghrib
            {
                setNotification(Constants.prayers[3], getDateComponent(For: prayerTimes.Maghrib))
            }
            //Isha prayer
            if alarmState.Isha
            {
                setNotification(Constants.prayers[4], getDateComponent(For: prayerTimes.Isha))
            }
        }
    }
    
    static func getDateComponent(For time:String) -> DateComponents {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: time)
        
        let dateComponent = Calendar.current.dateComponents([.hour,.minute], from: date!)
        
        return dateComponent
    }
    
    static func setNotification(_ prayer:String,_ dateComponent:DateComponents){
        
        // Boody content
        let content = UNMutableNotificationContent()
        content.title = "\(prayer) prayer"
        content.subtitle = "Now is the time fot the \(prayer) prayer"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("azahn.mp3"))
        
        // Create the trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        //Create request
       // let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: prayer, content: content, trigger: trigger)
        
        //Add notification to current center
        UNUserNotificationCenter.current().add(request)
    }
    static func removeAllNotifications(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
}
