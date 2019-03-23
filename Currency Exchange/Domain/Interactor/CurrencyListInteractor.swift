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
                currencyList.append(CurrencyModel(code: .EUR, rate: 1, amount: 0.0))
                entity.rates.forEach { arg in
                    let (key, value) = arg
                    if let code = CurrencyCode(rawValue: key),
                        let rate = value as? Double {
                        currencyList.append(CurrencyModel(code: code, rate: rate, amount: 0.0))
                    }
                }
                success(currencyList)
        }, failure: failure)
    }
}
