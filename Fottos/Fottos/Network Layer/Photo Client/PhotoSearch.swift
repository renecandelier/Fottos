//
//  File.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

public enum ApiError: String, Error {
    case invalidSearchTerm = "Empty Search Term"
    case parsingFailure = "An error occured while parsing"
    case imageFailed = "Image Failed to Download"
    case invalidRequestData = "The data requested is invalid"
}

struct PhotoSearch: RequestType {
    
    var searchTerm: String!
    var page: Int!
    var amountPerPage: Int!
    
    var dynamicQueryItems: [String: String] {
        return [ConfigKeys.text: searchTerm,
                ConfigKeys.page: page.toString,
                ConfigKeys.perPage: amountPerPage.toString]
    }
    
    var requestData: RequestData? {
        guard let url = url else { return .none }
        return RequestData(url: url)
    }
    
    private var url: URL? {
        guard let url = endpoint?.url, url.isValid else { return nil }
        return url
    }
    
    func fetchPhotos(completion: @escaping (PagedPhotoResponse?, Error?) -> Void) {
        
        if searchTerm.isEmpty { return completion(.none, ApiError.invalidSearchTerm) }
        
        execute { (json, _, _, error) in
            
            if let error = error { return completion(nil, error) }
            
            guard let photoDictionary = json, let pagedPhotoResponse = PhotoParser.parse(photoDictionary) else {
                return  completion(nil, ApiError.parsingFailure)
            }
            
            completion(pagedPhotoResponse, .none)
        }
    }
    
    private var endpoint: Endpoint? {
        guard let searchPhotosEndpoint = Config.shared.searchPhotosEndpoint else { return .none }
        return Endpoint(searchPhotosEndpoint, dynamicQueryItems: dynamicQueryItems)
    }
    
}
