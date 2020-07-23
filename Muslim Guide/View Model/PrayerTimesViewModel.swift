//
//  PrayerTimesViewModel.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/14/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift
class PrayerTimesViewModel: NSObject, ObservableObject {
    
    //MARK: - Private properties
    fileprivate var service:Service!
    fileprivate let realm = try! Realm()
    fileprivate var method = 3
    fileprivate var remaningTimer = Timer()
    fileprivate var earthRotationTimer = Timer()
     fileprivate  let locationManger=CLLocationManager()
    fileprivate var cureentLocation:Coordinate?
    {
        didSet{
            if let latitude = cureentLocation?.latitude, let longitude = cureentLocation?.longitude{
                self.service=Service(Constants.baseURL, PrayerTimesEndPoint(latitude: latitude, longitude: longitude, method: method))
                feachPrayerTimesFromServer()
            }
        }
    }
    fileprivate var nextPrayer:NextPrayer?
       {
           didSet{
               if let hours = nextPrayer?.remainingTime.hour , let minutes = nextPrayer?.remainingTime.minute, let name = nextPrayer?.name
               {
                   //Special case for (Fajr prayer)
                   if hours < 0
                   {
                       remainingTime = "\(hours+24) Hour \(minutes) Minutes left until \(name)"
                   }
                   else {
                       remainingTime = "\(hours) Hour \(minutes) Minutes left until \(name)"
                   }
               }
               
           }
       }
    //MARK: - Internal properties
    var currentDate:String
    {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMMM dd, yyyy"
        return dateFormat.string(from: Date())
    }
    var updateAlarmSatate:Int?
    {
        didSet{
            updateAlarmStateDB(indexPrayerTime: updateAlarmSatate ?? -1)
            guard let prayerTimes = todayPrayerTimes else {return}
            NotificationManger.scheduleNotifications(For: prayerTimes, alarmState)
        }
    }
    @Published var currentCity = CurrentCity()
    @Published var remainingTime=""
    @Published var earthRotationName = "e0"
    @Published var alarmState:AlarmState = AlarmState()
    @Published var todayPrayerTimes:PrayerTimesDB?
        {
        didSet{
            
            alarmState = self.realm.objects(AlarmState.self).last!
            
           NotificationManger.scheduleNotifications(For: todayPrayerTimes!, alarmState)
            
            setNextPrayer()
            startRemainingTime()
        }
    }
//MARK: - Initialize
    init(service:Service=Service(Constants.baseURL, PrayerTimesEndPoint(latitude: Constants.defultLatitude, longitude: Constants.defultLongitude, method: 3))) {
        super.init()
        self.service=service
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        
        NotificationManger.requestPermission()
        
        startEarthRotation()
        prepearData()
        
    }
    //MARK: - Methods
    func feachPrayerTimesFromServer(){
        service.feachPrayerTimes { [weak self](calendar, error) in
            
            guard let self = self else {return}
            guard error==nil else {
                print("\(String(describing: error?.localizedDescription))")
                return
            }
            if let calendar=calendar
            {
                DispatchQueue.main.async {
                    let today = TimeManger.getDayNumber()
                    let newCalendar = HelperFunctions.eraseBST(calendar: calendar)
                    self.savingData(calendar: newCalendar, cityName: self.currentCity)
                    self.todayPrayerTimes=HelperFunctions.castingData(from: newCalendar.data[today-1].timings)
                }
            }
            
        }
    }
    
}

//MARK: - CllocationManagerDelegate (Get location)
extension PrayerTimesViewModel:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location=locations.last
        {
            locationManger.stopUpdatingLocation()
            
            let geocoder=CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil
                {
                    print("error in reverseGeocodeLocation")
                }
                
                let placemark=placemarks?.last
                if let cityName=placemark?.locality ?? placemark?.subLocality, let country=placemark?.country
                {
                    DispatchQueue.main.async {
                        self.method=Constants.methods[Constants.defultMethodCountries[country] ?? Constants.defultMethod] ?? 3
                        let latitude=location.coordinate.latitude as Double
                        let longitude=location.coordinate.longitude as Double
                        self.cureentLocation = Coordinate(latitude: latitude, longitude: longitude)
                        self.currentCity.name = cityName
                    }
                    
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
}
//MARK: - Prepear data from dataBase(Realm DataBase) or Feachin from Server(AlamoFire), Saving data
extension PrayerTimesViewModel
{
    
    func prepearData() {
        //Get currentCity from dataBase
        if let feachedCurrentCity = getCurrentCity()
        {
            currentCity = feachedCurrentCity
            
            if (!getTodayPrayerTimes(for: currentCity.name))
            {
                //Get your location and then feaching data from server
                locationManger.requestLocation()
                
            }
        }
            //i will remove this code when i implement lanching view
        else{
            //Get your location and then feaching data from server
            locationManger.requestLocation()
        }
    }
    
    func getCurrentCity() -> CurrentCity? {
        
        let currentCityObjects = realm.objects(CurrentCity.self)
        return currentCityObjects.last
    }
    func getTodayPrayerTimes(for city:String) -> Bool {
        let feachedCity = realm.objects(City.self).filter("name == %@", city)
        let calendar = feachedCity.last?.calendar.filter("year == %@", TimeManger.getYearNumber())
        let prayerTimes = calendar?.filter("month == %@",TimeManger.getMonthNumber()).last
        todayPrayerTimes=prayerTimes?.prayerTimes[TimeManger.getDayNumber()-1]
        return (todayPrayerTimes != nil) ? true:false
    }
    
    //saving data
    func savingData(calendar:PrayerCalendar, cityName:CurrentCity){
        
        let oneMonthCalendar = PrayerTimesCalendar()
        
        guard let year = Int(calendar.data[0].date.gregorian.year) else {return}
        oneMonthCalendar.year = year
        oneMonthCalendar.month = calendar.data[0].date.gregorian.month.number
        
        for timings in calendar.data
        {
            let prayerTimesDB = HelperFunctions.castingData(from: timings.timings)
            oneMonthCalendar.prayerTimes.append(prayerTimesDB)
        }
        
        let newCity = City()
        newCity.name=cityName.name
        newCity.method = method
        newCity.calendar.append(oneMonthCalendar)
        
        let alarmState = AlarmState()
        do {
            try realm.write{
                realm.add(newCity)
                realm.add(cityName)
                realm.add(alarmState)
            }
        } catch  {
            print("Not Saving Data")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    func updateAlarmStateDB(indexPrayerTime:Int) {
        
        do {
            try realm.write{
                if indexPrayerTime == 0
                {
                    alarmState.Fajr = !alarmState.Fajr
                }
                else if indexPrayerTime == 1
                {
                    alarmState.Dhuhr = !alarmState.Dhuhr
                }
                else if indexPrayerTime == 2
                {
                    alarmState.Asr = !alarmState.Asr
                }
                else if indexPrayerTime == 3
                {
                    alarmState.Maghrib = !alarmState.Maghrib
                }
                else if indexPrayerTime == 4
                {
                    alarmState.Isha = !alarmState.Isha
                }
                
            }
        } catch  {
            print("Error, Don't enabled Alarm")
        }
    }
}


//MARK: - Calculate next prayer and count down timer
extension PrayerTimesViewModel
{
    
    
    func getNextPrayerIndex() -> Int{
        
        // date now by minutes
        let now = (TimeManger.getHourNumber() * 60) + TimeManger.getMinuteNumber()
        
        // date for all prayers by minutes
        let Fajr = (Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Fajr).components(separatedBy: ":")[0])! * 60) + Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Fajr).components(separatedBy: ":")[1])!
        
        //        let Sunrise = (Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Sunrise).components(separatedBy: ":")[0])! * 60) + Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Sunrise).components(separatedBy: ":")[1])!
        
        let Dhuhr = (Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Dhuhr).components(separatedBy: ":")[0])! * 60) + Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Dhuhr).components(separatedBy: ":")[1])!
        
        let Asr = (Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Asr).components(separatedBy: ":")[0])! * 60) + Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Asr).components(separatedBy: ":")[1])!
        
        let Maghrib = (Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Maghrib).components(separatedBy: ":")[0])! * 60) + Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Maghrib).components(separatedBy: ":")[1])!
        
        let Isha = (Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Isha).components(separatedBy: ":")[0])! * 60) + Int( TimeManger.convertTimeFormatTo_24(time: todayPrayerTimes!.Isha).components(separatedBy: ":")[1])!
        
        var prayer = 0
        
        if( now > Fajr && now <= Dhuhr)
        {
            prayer = 1
        }
        else if ( now > Dhuhr && now <= Asr){
            prayer = 2
        }
        else if ( now > Asr && now <= Maghrib){
            prayer = 3
        }
        else if ( now > Maghrib && now <= Isha){
            prayer = 4
        }
        else if ( now > Isha && now <= (Fajr + (24 * 60))){
            prayer = 0
        }
        return prayer
    }
    
    func setNextPrayer() {
        let indexPrayer = getNextPrayerIndex()
        let prayer = Constants.prayers[indexPrayer]
        nextPrayer = NextPrayer(name: prayer , count: indexPrayer, remainingTime: TimeManger.getRemainingTime(prayerTime: HelperFunctions.getPrayerTime(prayerName: prayer, prayerTimes: todayPrayerTimes!)))
    }
    
    func startRemainingTime() {
        remaningTimer.invalidate()
        remaningTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(countDownTimer), userInfo: nil, repeats: true)
    }
    @objc func countDownTimer(){
        if((nextPrayer?.remainingTime.minute)! > 0)
        {
            nextPrayer?.remainingTime.minute -= 1
        }
        else if((nextPrayer?.remainingTime.hour)! > 0)
        {
            nextPrayer?.remainingTime.hour -= 1
            nextPrayer?.remainingTime.minute = 59
        }
        else{
            nextPrayer?.count += 1
            nextPrayer?.count %= 6
            let count = nextPrayer?.count
            let name = Constants.prayers[nextPrayer!.count]
            nextPrayer = NextPrayer(name: name, count: count!, remainingTime: TimeManger.getRemainingTime(prayerTime: HelperFunctions.getPrayerTime(prayerName: name, prayerTimes: todayPrayerTimes!)))
        }
    }
}

//MARK: - Render and loading  Earth rotation in view
extension PrayerTimesViewModel
{
    
    func startEarthRotation()  {
        earthRotationTimer.invalidate()
        earthRotationTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(nextImageName), userInfo: nil, repeats: true)
    }
    
    
    @objc func nextImageName()  {
        
        var newImageName = "e0"
        if let index = Int(earthRotationName.components(separatedBy: "e")[1])
        {
            var newIndex = index
            
            newIndex += 1
            newIndex %= 22
            
            newImageName = "e\(newIndex)"
        }
        earthRotationName = newImageName
    }
    
}
