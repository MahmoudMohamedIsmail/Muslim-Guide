//
//  RemainingTime.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/20/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import Foundation
//MARK: - NextPrayer
struct NextPrayer {
    var name:String
    var count:Int
    var remainingTime:RemainingTime
}
//MARK: - RemainingTime
struct RemainingTime {
    var hour:Int
    var minute:Int
}
