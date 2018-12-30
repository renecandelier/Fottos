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
        
        guard let photosDictionary = photoJson[Keys.photos] as? PhotoDictionary,
            let photosArray = photosDictionary[Keys.photo] as? [PhotoDictionary] else { return .none }
        
        let total = Int(photosDictionary[Keys.total] as? String ?? "0")!
        let page = photosDictionary[Keys.page] as? Int ?? 0
        let photos = photosArray.compactMap { PhotoStruct.createPhoto($0) }
        let pagedPhotoResponse = PagedPhotoResponse(total: total, page: page, photos: photos)
        return pagedPhotoResponse
    }
}
