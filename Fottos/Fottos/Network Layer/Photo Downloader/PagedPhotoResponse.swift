//
//  PagedPhotoResponse.swift
//  Fottos
//
//  Created by Rene Candelier on 12/28/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

struct PagedPhotoResponse {
    let total: Int
    let page: Int
    let photos: [Photo]
    
    init?(_ photosDictionary: PhotoDictionary) {
        guard let photosArray = photosDictionary[Keys.photo] as? [PhotoDictionary] else { return nil }
        total = Int(photosDictionary[Keys.total] as? String ?? "0") ?? 0
        page = photosDictionary[Keys.page] as? Int ?? 0
        photos = photosArray.compactMap { PhotoStruct($0) }
    }
}
