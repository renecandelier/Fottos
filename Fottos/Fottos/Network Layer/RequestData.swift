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
public typealias Components = (key: String, value: String)

public enum DataType {
    case JSON
    case Data
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
