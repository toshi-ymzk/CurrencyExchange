//
//  CurrencyModel.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

struct CurrencyModel {
    
    var name: String
    var rate: Double
    
    init(name: String, rate: Double) {
        self.name = name
        self.rate = rate
    }
}
