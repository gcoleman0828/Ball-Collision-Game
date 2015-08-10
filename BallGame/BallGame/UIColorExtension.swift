//
//  UIColorExtension.swift
//  BallGame
//
//  Created by GreggColeman on 7/23/15.
//  Copyright (c) 2015 Gregg Coleman. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // Extends the UIColor class to allow the conversion 
    // from Hex -> RGB
    convenience init(hex: Int, alpha: CGFloat = 1.0){
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
}