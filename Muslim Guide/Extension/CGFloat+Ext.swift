//
//  CGFloat+Ext.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/26/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import UIKit
extension CGFloat {
  var degreesToRadians: CGFloat { return self * .pi / 180 }
  var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
