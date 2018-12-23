//
//  Utils.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import UIKit

var emptyString = ""

extension URL {
    var isValid:  Bool {
        return UIApplication.shared.canOpenURL(self)
    }
}

extension Int {
    var toString: String {
        return self.description
    }
}

struct Keys {
    static let photos = "photos"
    static let photo = "photo"
    static let photoId = "id"
    static let secret = "secret"
    static let server = "server"
    static let farm = "farm"
    static let title = "title"
    
    struct QueryItems {
        static let method = "method"
        private init () {}
    }
    private init () {}
}

extension UIImageView {
    func dowloadFromServer(url: URL) {
        let photo = PhotoDownload(url: url)
        photo.dowloadFromServer { (image, error) in
            if let image = image {
                DispatchQueue.main.async() {
                    self.image = image
                }
            }
        }
    }
}
