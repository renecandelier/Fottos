//
//  Config.swift
//  Fottos
//
//  Created by Rene Candelier on 1/2/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

struct ConfigKeys {
    static let version = "version"
    static let categories = "categories"
    static let endpoint = "endpoints"
    static let photoDownload = "photoDownload"
    static let photoSearch = "photoSearch"
    static let image = "image"
    static let title = "title"
    static let url = "url"
    static let host = "host"
    static let type = "type"
    static let build = "build"
    static let components = "components"
    static let queryItems = "queryItems"
    static let path = "path"
    static let scheme = "scheme"
    static let text = "text"
    static let page = "page"
    static let perPage = "per_page"
    
    private init() {}
}

class Config {
    
    public static let shared = Config()
    
    fileprivate var configDictionary: ConfigDictionary
    fileprivate static let configJson = "FottosConfig.json"

    private init() {
        let path = applicationDocumentsDirectory.appendingPathComponent(Config.configJson)
        if let data = try? Data(contentsOf: path), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? ConfigDictionary, let unwrappedJson = json {
            configDictionary = unwrappedJson
        } else {
            configDictionary = [:]
        }
    }
    
    open func updateConfig(_ configuration: ConfigDictionary) {
        configDictionary = configuration
        
        let path = applicationDocumentsDirectory.appendingPathComponent(Config.configJson)
        
        if let data = try? JSONSerialization.data(withJSONObject: configDictionary, options: []) {
            try? data.write(to: path, options: [.atomic])
        }
    }
    
    var version: String {
        return configDictionary[ConfigKeys.version] as? String ?? ""
    }
    
    var categories: [Category] {
        if let categoriesArray = configDictionary[ConfigKeys.categories] as? [CategoryDictionary] {
            return categoriesArray.compactMap { Category($0) }
        }
        return []
    }
    
    var searchPhotosEndpoint: SearchPhotos? {
        guard let endpoints = endpoints, let searchPhotosEndpoint = endpoints[ConfigKeys.photoSearch] as? SearchPhotosDictionary else { return .none }
        return SearchPhotos(searchPhotosEndpoint)
    }
    
    var photoDownloadEndpoint: PhotoDownload? {
        guard let endpoints = endpoints, let photoDownloadingEndpoint = endpoints[ConfigKeys.photoDownload] as? PhotoDownloadDictionary else { return .none }
        return PhotoDownload(photoDownloadingEndpoint)
    }
    
    var endpoints: EndpointDictionary? {
        return configDictionary[ConfigKeys.endpoint] as? EndpointDictionary
    }
    
    var fetchPerPage: Int {
        return FetchPerPage.getAmount()
    }
    
}
