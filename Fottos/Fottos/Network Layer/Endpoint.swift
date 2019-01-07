//
//  Endpoint.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

enum EndPointType {
    case build
    case components
}

struct Endpoint {
    var scheme: String?
    var host: String?
    var path: String
    var urlQueryItems: [URLQueryItem]?
    var replacementTokens: ReplacementTokens?
    var type: EndPointType
    
    init(_ searchPhotos: SearchPhotos, dynamicQueryItems: [String : String]) {
        host = searchPhotos.host
        scheme = searchPhotos.scheme
        path = searchPhotos.path
        type = .components
        var queryItems = searchPhotos.queryItems
        queryItems.combine(dynamicQueryItems)
        
        urlQueryItems = getQueryItems(queryItems)
    }
    
    init(urlPath path: String, replacementTokens: ReplacementTokens) {
        self.path = path
        type = .build
        self.replacementTokens = replacementTokens
    }
}

extension Endpoint {
    
    var url: URL? {
        switch type {
        case .build:
            guard let endPointURL = endPointURL else { return .none }
            return endPointURL
        case .components:
            return componentsURL
        }
    }
    
    private func getQueryItems(_ queryDictionary: [String: String]?) -> [URLQueryItem]? {
        guard let queryDictionary = queryDictionary else { return .none }
        var quertItems = [URLQueryItem]()
        
        queryDictionary.forEach {
            let newItem = URLQueryItem(name: $0.key, value: $0.value)
            quertItems.append(newItem)
        }
        
        return quertItems
    }
    
    private var componentsURL: URL? {
        var components = URLComponents()
        components.path = path
        components.host = host
        components.scheme = scheme
        components.queryItems = urlQueryItems
        return components.url
    }
    
    private var endPointURL: URL? {
        return URL(string: populatedEndPoint)
    }
    
    private var populatedEndPoint: String {
        var populatedEndPoint = path
        
        if let replacementTokens = replacementTokens {
            for (key, value) in replacementTokens {
                populatedEndPoint = populatedEndPoint.replacingOccurrences(of: "\(key)", with: value)
            }
        }
        return populatedEndPoint
    }
    
}
