//
//  APIRouter.swift
//  Currency Exchange
//
//  Created by Toshihiro Nojima on 2019/03/22.
//  Copyright © 2019 Toshihiro Yamazaki. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol APIRouter: URLConvertible {
    var path  : String { get }
    var params: [String : Any] { get }
    var method: HTTPMethod { get }
    var encode: ParameterEncoding { get }
}

extension APIRouter {
    
    func requestObject<T: Mappable>(
        success: @escaping (T) -> Void,
        failure: @escaping (_ error: Error) -> Void) {
        
        let req = SessionManager.default.request(self, method: method, parameters: params, encoding: encode).validate()
        req.response(responseSerializer: responseSeriqlizer(T.self)) { (response: DataResponse<T>) in
            switch(response.result) {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func responseSeriqlizer<T: Mappable>(_ type: T.Type) -> DataResponseSerializer<T> {
        return DataResponseSerializer<T>(serializeResponse: { (req, res, data, error) in
            if let error = error {
                return .failure(error)
            }
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(req, res, data, error)
            switch result {
            case .success(let value):
                if let json = value as? [String: AnyObject],
                    let responseObject = Mapper<T>().map(JSON: json) {
                    return .success(responseObject)
                }
                return .failure(NSError(domain: "", code: 0, userInfo: nil))
            case .failure(let error):
                return .failure(error)
            }
        })
    }
}
