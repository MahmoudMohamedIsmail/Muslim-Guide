//
//  BackgroundManger.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/22/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import BackgroundTasks
import RealmSwift
class BackgroundManger {
    
    static func registerBackgroundTasks()
    {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Constants.appRefresh, using: nil) { (task) in
            handleNotifications(task: task as! BGAppRefreshTask)
        }
    }
    static func handleNotifications(task: BGAppRefreshTask) {
        
        guard let prayerTimes = getPrayerTimes() else {
            return
        }
        guard let alarmState = getAlarmState() else {
                   return
               }
        NotificationManger.scheduleNotifications(For: prayerTimes, alarmState)
        
//        //Todo Work
//        /*
//         //AppRefresh Process
//         */
//        task.expirationHandler = {
//            //This Block call by System
//            //Canle your all tak's & queues
//        }
        
        task.setTaskCompleted(success: true)
        scheduleNotifications()
    }
    static func scheduleNotifications(){
        
        let request = BGAppRefreshTaskRequest(identifier: Constants.appRefresh)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 86400) // request task every day(86400 = 24*60*60) .
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule notifications (appRefresh) \(error)")
        }
        
    }
    static func cancelAllPendingBGTasks() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    //MARK: - Get prayer times from dataBase
   static func getPrayerTimes() -> PrayerTimesDB? {
        
        let realm = try! Realm()
        
        if let currentCityObjects = realm.objects(CurrentCity.self).last
        {
            let feachedCity = realm.objects(City.self).filter("name == %@", currentCityObjects.name)
            let calendar = feachedCity.last?.calendar.filter("year == %@", TimeManger.getYearNumber())
            let prayerTimes = calendar?.filter("month == %@",TimeManger.getMonthNumber()).last
            
            return prayerTimes?.prayerTimes[TimeManger.getDayNumber()-1]
            
        }
        
        return nil
    }
    static func getAlarmState() -> AlarmState? {
        let realm = try! Realm()
        return realm.objects(AlarmState.self).last
    }
}
