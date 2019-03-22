//
//  CurrencyListInteractor.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import ObjectMapper

class CurrencyListInteractor {
    
    let api: RevolutAPIProtocol
    
    init(api: RevolutAPIProtocol) {
        self.api = api
    }
    
    func getCurrencyList(success: @escaping ([CurrencyModel]) -> Void,
                         failure: @escaping (Error) -> Void) {
        api.getLatestExchangeRates(
            params: ["base": "EUR"],
            success: { entity in
            var currencyList = [CurrencyModel]()
            currencyList.append(CurrencyModel(name: entity.base, rate: 1))
            entity.rates.forEach { arg in
                let (key, value) = arg
                if let rate = value as? Double {
                    currencyList.append(CurrencyModel(name: key, rate: rate))
                }
            }
            success(currencyList)
        }, failure: failure)
    }
}
