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
    
    
    // TODO: Finish parsing
//    func parse(_ dictionary: [String: Any]) -> PagedPhotoResponse? {
//        if let total = dictionary[Keys.total] as? String {
//
//        }
//    }
}
