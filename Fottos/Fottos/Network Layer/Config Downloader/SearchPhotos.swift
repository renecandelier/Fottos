//
//  SearchPhotos.swift
//  Fottos
//
//  Created by Rene Candelier on 1/2/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

typealias SearchPhotosDictionary = [String: Any]
typealias QueryItems = [String: String]

struct SearchPhotos {

    // MARK: - Properties

    var urlBuildType: EndPointType = .components
    var queryItems: QueryItems = [:]
    var url = ""
    var host = ""
    var scheme = ""
    var path = ""
    
    init(_ searchPhotosDictionary: SearchPhotosDictionary) {
        parse(searchPhotosDictionary)
    }
    
    mutating func parse(_ searchPhotosDictionary: SearchPhotosDictionary) {
        queryItems = searchPhotosDictionary[ConfigKeys.queryItems] as? QueryItems ?? [:]
        url = searchPhotosDictionary[ConfigKeys.url] as? String ?? ""
        host = searchPhotosDictionary[ConfigKeys.host] as? String ?? ""
        path = searchPhotosDictionary[ConfigKeys.path] as? String ?? ""
        scheme = searchPhotosDictionary[ConfigKeys.scheme] as? String ?? ""
    }
}
