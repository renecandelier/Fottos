//
//  RequestType.swift
//  Fottos
//
//  Created by Rene Candelier on 1/1/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

public protocol RequestType {
    var requestData: RequestData? { get }
}

public extension RequestType {
    public func execute(dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher.instance,
                        completionHandler: @escaping NetworkCompletionHandler) {
        
        guard let requestData = requestData else { return completionHandler(nil, nil, nil, ApiError.invalidRequestData) }
        
        dispatcher.dispatch(requestData: requestData) { (responseData, response, error) in
            if let error = error { completionHandler(nil, nil, nil, error); return  }
            guard let responseData = responseData else { return completionHandler(nil, nil, nil, error) }
            
            if requestData.dataType == .Data {
                completionHandler(nil, responseData, response, nil)
                return
            }
            
            do {
                let json = try self.getJson(responseData)
                completionHandler(json, nil, nil, nil)
            } catch let jsonError {
                completionHandler(nil, nil, nil, jsonError)
            }
        }
    }
    
    private func getJson(_ data: Data) throws -> JsonDictionary? {
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary ?? [:]
            
            return json
            
        } catch let error {
            throw error
        }
    }
}
