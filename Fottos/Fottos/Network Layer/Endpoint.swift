//
//  Endpoint.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

//protocol EndpointComponents {
//    let path: String
//    let urlComponents: URLComponents
//}

struct Endpoint {
    let path: String
    let urlQueryItems: [URLQueryItem]
    var replacementTokens: [String: String]?
//    var type: Type = .build
}

extension Endpoint {
    
//    enum Type {
//        case build
//        case components
//    }
    
    var url: URL? {
        var components = URLComponents()
        components.path = path
        components.host = "api.flickr.com"
        components.scheme = "https"
        components.queryItems = urlQueryItems
        return components.url
    }
    
//    func buildURL(replacementTokens: [String: String]) -> URL {
//        var urlPath = path
//        for (key, value) in replacementTokens {
//            populatedEndPoint = populatedEndPoint.replacingOccurrences(of: "\(key)", with: value)
//        }
//    }
}
