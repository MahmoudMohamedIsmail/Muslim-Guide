//
//  AlarmEnabled.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/24/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
import RealmSwift
//MARK: - AlarmState
class AlarmState: Object {
    @objc dynamic var Fajr = true
    @objc dynamic var Dhuhr = true
    @objc dynamic var Asr = true
    @objc dynamic var Maghrib = true
    @objc dynamic var Isha = true
}
