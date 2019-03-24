//
//  Double+.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/24.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

extension Double {
    
    func truncate(_ decimalPlaces: Double) -> Double {
        let n = pow(10.0, decimalPlaces)
        return floor(self * n) / n
    }
}
