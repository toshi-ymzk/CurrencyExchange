//
//  Double+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/24.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

extension Double {
    
    func truncate(_ decimalPlaces: Int) -> Double {
        let n = pow(10.0, Double(decimalPlaces))
        return floor(self * n) / n
    }
}
