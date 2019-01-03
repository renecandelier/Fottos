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
    var title: String?
    
    init(_ photo: PhotoDictionary) {
        imageId = photo[Keys.photoId] as? String ?? emptyString
        secret = photo[Keys.secret] as? String ?? emptyString
        server = photo[Keys.server] as? String ?? emptyString
        farm = photo[Keys.farm] as? Int ?? 0
        title = photo[Keys.title] as? String ?? emptyString
    }
    
    var imageURL: URL? {
        guard let url = getEndpoint?.url, url.isValid else { return .none }
        return url
    }
    
    var url: String? {
        return getEndpoint?.url?.absoluteString
    }

    private var getEndpoint: Endpoint? {
        guard let photoDownloadEndpoint = Config.shared.photoDownloadEndpoint else { return .none }
        
        guard let farm = farm, let server = server, let secret = secret, let imageId = imageId else { return .none }
        
        let replacementTokens = ["{farm}": "\(farm)",
            "{server}": server,
            "{imageId}": imageId,
            "{secret}":secret]

        return Endpoint(urlPath: photoDownloadEndpoint.url, replacementTokens: replacementTokens)
    }

}


