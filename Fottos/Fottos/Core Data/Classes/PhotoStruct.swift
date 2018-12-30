//
//  Photo.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

struct PhotoStruct: Photo {
    let farm: Int?
    let server: String?
    let imageId: String?
    let secret: String?
    let title: String?
    let total: String?
    
    var imageURL: URL? {
        guard let url = buildURL(), url.isValid else { return .none }
        return url
    }
    
    var url: String? {
        return imageURL?.absoluteString
    }
    
    private func buildURL() -> URL? {
        guard let farm = farm, let server = server, let secret = secret, let imageId = imageId else { return .none }
        return URL(string:"https://farm\(farm).staticflickr.com/\(server)/\(imageId)_\(secret).jpg")
    }
    
    static func createPhoto(_ photo: PhotoDictionary) -> PhotoStruct {
        let imageId = photo[Keys.photoId] as? String ?? emptyString
        let secret = photo[Keys.secret] as? String ?? emptyString
        let server = photo[Keys.server] as? String ?? emptyString
        let farm = photo[Keys.farm] as? Int ?? 0
        let title = photo[Keys.title] as? String ?? emptyString
        
        return PhotoStruct(farm: farm, server: server, imageId: imageId, secret: secret, title: title, total: "")
    }
}


