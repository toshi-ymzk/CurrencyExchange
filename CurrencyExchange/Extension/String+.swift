//
//  String+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/26.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation

extension String {
    
    func addDecimalComma() -> String? {
        if Double(self) == nil {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let firstString = split(separator: ".").first ?? "0"
        let lastString = split(separator: ".").last ?? ""
        var result = formatter.string(from: NSNumber(value: Int(firstString) ?? 0)) ?? "0"
        if contains(".") {
            result += "."
        }
        if split(separator: ".").count > 1 {
            result += lastString
        }
        return result
    }
}
