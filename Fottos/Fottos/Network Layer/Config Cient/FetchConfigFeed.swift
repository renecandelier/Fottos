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
        
        execute { (jsonFromServer, _, _, _) in
            
            let configJson = jsonFromServer ?? self.localJSON
            Config.shared.updateConfig(configJson)
            completion(configJson, .none)
        }
    }
    
    var localJSON: ConfigDictionary {
        guard let jsonURL = Bundle.main.url(forResource: "config", withExtension: "json"),
            let json = jsonURL.serializeJSON(type: ConfigDictionary.self) else { return [:] }
        return json
    }
}
