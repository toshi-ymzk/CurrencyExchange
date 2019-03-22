//
//  RevolutAPIStub.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import ObjectMapper

class RevolutAPIStub: RevolutAPIProtocol {
    
    public func getLatestExchangeRates(
        params: [String : Any],
        success: @escaping (ExchangeRatesEntity) -> Void,
        failure: @escaping (Error) -> Void) {
        let json = loadStubData(name: "exchange_rates", type: "json")
        if let entity = Mapper<ExchangeRatesEntity>().map(JSON: json) {
            success(entity)
        } else {
            failure(NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    func loadStubData(name: String, type: String) -> [String : Any] {
        guard let path = Bundle.main.path(forResource: "Stub", ofType: "bundle"),
            let bundle = Bundle(path: path),
            let url = bundle.url(forResource: name, withExtension: type),
            let data = try? Data(contentsOf: url),
            let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let json = obj as? [String : Any] else {
                return [:]
        }
        return json
    }
}
