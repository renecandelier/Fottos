//
//  File.swift
//  Fottos
//
//  Created by Rene Candelier on 12/22/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

typealias PhotoDictionary = [String: Any]

struct PhotoParser {
    static func parse(_ photoJson: PhotoDictionary) -> PagedPhotoResponse? {
        
        guard let photosDictionary = photoJson[Keys.photos] as? PhotoDictionary, let pagedPhotoResponse = PagedPhotoResponse(photosDictionary)
             else { return .none }
        
        return pagedPhotoResponse
    }
}
