//
//  FetchConfigFeed.swift
//  Fottos
//
//  Created by Rene Candelier on 1/2/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

struct FectConfigFeed: RequestType {
    
    // MARK: - Constants
    
    let tokenKey = ":version"
    let configBundle = "CONFIG_URL"
    
    var requestData: RequestData? {
        guard let url = url else { return .none }
        return RequestData(url: url)
    }

    private var url: URL? {
        guard let url = endpoint?.url, url.isValid else { return nil }
        return url
    }
    
    private var replacementTokens: ReplacementTokens {
        return [tokenKey: appVersionNumber]
    }
    
    private var endpoint: Endpoint? {
        guard let configURL = configBundle.bundleValue else { return .none }
        return Endpoint(urlPath: configURL, replacementTokens: replacementTokens)
    }

    func fetchConfig(completion: @escaping (JsonDictionary?, Error?) -> Void) {
        
        execute { (json, _, _, error) in
            
            if let error = error { return completion(nil, error) }
            if let json = json {
                Config.shared.updateConfig(json)
            }
            
            completion(json, .none)
        }
    }
}
