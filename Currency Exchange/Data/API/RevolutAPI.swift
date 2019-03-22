//
//  RevolutAPI.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation
import ObjectMapper

class RevolutAPI: RevolutAPIProtocol {
    
    public func getLatestExchangeRates(
        params: [String : Any],
        success: @escaping (ExchangeRatesEntity) -> Void,
        failure: @escaping (Error) -> Void) {
        RevolutAPIRouter.getLatestExchangeRates(params).requestObject(success: success, failure: failure)
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
