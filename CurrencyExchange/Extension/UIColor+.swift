//
//  UIColor+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/25.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func hexColor(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
