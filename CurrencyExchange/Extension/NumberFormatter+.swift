//
//  NumberFormatter+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/04/27.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    func addDecimalComma(str: String?) -> String? {
        guard let str = str,
            Double(str) != nil,
            let intStr = str.split(separator: ".").first,
            let int = Int(intStr) else {
                return nil
        }
        numberStyle = .decimal
        // Add dicimal comma
        var result = string(from: NSNumber(value: int)) ?? "0"
        // Add dicimal point
        if str.contains(".") {
            result += "."
        }
        // Add number after dicimal point if needed
        if str.split(separator: ".").count > 1 {
            result += str.split(separator: ".").last ?? ""
        }
        return result
    }
}
