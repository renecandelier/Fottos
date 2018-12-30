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
    
    var searchTerm: String
    var page: Int
    var amountPerPage: Int
    
    var requestData: RequestData? {
        guard let url = getURL() else { return .none }
        return RequestData(url: url)
    }
    
    private func getURL() -> URL? {
        guard let url = getEndpoint().url, url.isValid else { return nil }
        return url
    }
    
    func fetchPhotos(completion: @escaping (PagedPhotoResponse?, Error?) -> Void) {
        
        if searchTerm.isEmpty { return completion(.none, ApiError.invalidSearchTerm) }
        
        execute { (json, _, _, error) in
            
            if let error = error { return completion(nil, error) }
            
            guard let photoDictionary = json, let pagedPhotoResponse = PhotoParser.parse(photoDictionary)
                else { return  completion(nil, ApiError.parsingFailure)}
            
            completion(pagedPhotoResponse, .none)
        }
    }
    
    private func getEndpoint() -> Endpoint {
        return Endpoint(path: "/services/rest/", urlQueryItems: getQueryItems(), replacementTokens: nil)
    }
    
    func getQueryItems() -> [URLQueryItem] {
        let queryItems = [
            URLQueryItem(name: Keys.QueryItems.method, value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "1508443e49213ff84d566777dc211f2a"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "per_page", value: amountPerPage.toString),
            URLQueryItem(name: "page", value: page.toString),
            URLQueryItem(name: "text", value: searchTerm)
        ]
        return queryItems
    }
}
