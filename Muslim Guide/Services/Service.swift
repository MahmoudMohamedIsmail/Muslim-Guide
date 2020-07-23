//
//  Service.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/11/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import Alamofire

struct PrayerTimesEndPoint {
    let latitude:Double
    let longitude:Double
    let method:Int
}
class Service {
    
    fileprivate var baseURL=""
    
    init(_ baseURL:String,_ endPoint:PrayerTimesEndPoint) {
       self.baseURL=baseURL + "latitude=\(endPoint.latitude)&longitude=\(endPoint.longitude)&method=\(endPoint.method)"
        //self.baseURL=baseURL + "latitude=\(endPoint.latitude)&longitude=\(endPoint.longitude)"
    }
    
    func feachPrayerTimes(completionHandler: @escaping (_ calendar:PrayerCalendar?,_ error:AFError?)->()){
        AF.request(self.baseURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON { (responesData) in
            guard let data=responesData.data else {
                completionHandler(nil,responesData.error)
                return
            }
            do
            {
               let jsonData=try JSONDecoder().decode(PrayerCalendar.self, from: data)
                completionHandler(jsonData,nil)

            }
            catch
            {
                completionHandler(nil,(error as! AFError))
               // print("Decoding error is \(error.localizedDescription)")
            }
            
        }
     
    }
}
