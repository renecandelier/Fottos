//
//  NetworkDispatcher.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

public protocol NetworkDispatcher {
    func dispatch(requestData: RequestData, completionHandler: @escaping NetworkResponseCompletionHandler)
}

public struct URLSessionNetworkDispatcher: NetworkDispatcher {
    public static let instance = URLSessionNetworkDispatcher()
    private init() {}
    
    public func dispatch(requestData: RequestData, completionHandler: @escaping NetworkResponseCompletionHandler) {
        
        var urlRequest: URLRequest
        
        do {
            urlRequest = try buildUrlRequest(requestData: requestData)
        } catch let error {
            completionHandler(nil, nil, error)
            return
        }
        
        urlRequest.httpMethod = requestData.method.rawValue
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                completionHandler(nil, nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode else {
                completionHandler(nil, nil, NetworkError.network)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, nil, NetworkError.noData)
                return
            }
            
            completionHandler(data, response, nil)
            }.resume()
    }
    
    func buildUrlRequest(requestData: RequestData) throws -> URLRequest {
        var urlRequest = URLRequest(url: requestData.url)
        urlRequest.httpMethod = requestData.method.rawValue
        do {
            try addParameters(parameters: requestData.parameters, urlRequest: &urlRequest)
        } catch let error {
            throw error
        }
        return urlRequest
    }
    
    func addParameters(parameters: Parameters?, urlRequest: inout URLRequest) throws {
        do {
            if let parameters = parameters {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
        } catch let error {
            throw error
        }
    }
}
