//
//  RevolutAPIRouter.swift
//  CurrencyExchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Alamofire

protocol RevolutAPIProtocol {
    func getLatestExchangeRates(
        params: [String : Any],
        success: @escaping (ExchangeRatesEntity) -> Void,
        failure: @escaping (Error) -> Void)
}

enum RevolutAPIRouter: APIRouter {
    
    case getLatestExchangeRates([String : Any])
    
    var endpoint: String {
        return "https://revolut.duckdns.org"
    }
    
    var path  : String {
        switch self {
        case .getLatestExchangeRates:
            return "/latest"
        }
    }
    
    var params: [String : Any] {
        switch self {
        case .getLatestExchangeRates(let params):
            return params
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encode: ParameterEncoding {
        return URLEncoding.default
    }
    
    func asURL() throws -> URL {
        return URL(string: endpoint + path) ?? URL(fileURLWithPath: "")
    }
}
