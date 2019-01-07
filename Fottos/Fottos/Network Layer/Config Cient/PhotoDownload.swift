//
//  PhotoDownload.swift
//  Fottos
//
//  Created by Rene Candelier on 1/2/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

struct PhotoDownload {
    
    // MARK: - Properties
    
    var url = ""
    var buildType: EndPointType = .build
    
    init(_ dictionary: PhotoDownloadDictionary) {
        parse(dictionary)
    }
    
    mutating func parse(_ dictionary: PhotoDownloadDictionary) {
        url = dictionary[ConfigKeys.url] ?? ""
        buildType = dictionary[ConfigKeys.type] == ConfigKeys.build ? .build : .components
    }
}
