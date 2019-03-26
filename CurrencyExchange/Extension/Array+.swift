//
//  Array+.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/23.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

extension Array {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
