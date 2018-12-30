//
//  RequestData.swift
//  Fottos
//
//  Created by Rene Candelier on 12/20/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

public typealias NetworkCompletionHandler = ((JsonDictionary?, Data?, URLResponse?, Error?) -> Void)

public typealias NetworkResponseCompletionHandler = ((Data?, URLResponse?, Error?) -> Void)

public typealias JsonDictionary = [String: Any]

public typealias Parameters = [String: Any]

public enum NetworkError: String, Error {
    case invalidURL = "URL is invalid."
    case noData = "No data availale."
}

public enum DataType {
    case JSON
    case Data
}

public enum HTTPMethod: String {
    case get = "GET"
    case update = "UPDATE"
    case post = "POST"
}

public struct RequestData {
    public let url: URL
    public var method: HTTPMethod = .get
    public var parameters: Parameters? = nil
    public var headers: [String: String]? = nil
    public var dataType: DataType
    
    init(url: URL, dataType: DataType = .JSON, method: HTTPMethod = .get) {
        self.url = url
        self.method = method
        self.dataType = dataType
    }
}

public enum RequestParams {
    case body(_ : [String: Any]?)
    case url(_ : [String: Any]?)
}

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: RequestParams { get }
    var headers: [String: Any]? { get }
    var dataType: DataType { get }
}

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
    
    func getJson(_ data: Data) throws -> JsonDictionary? {
        do {
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary ?? [:]
            
            return json
            
        } catch let error {
            throw error
        }
    }
}
