//
//  ExchangeRatesEntity.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import ObjectMapper

class ExchangeRatesEntity: Mappable {
    
    var base = ""
    var rates = [String : Any]()
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        base <- map["base"]
        rates <- map["rates"]
    }
}
