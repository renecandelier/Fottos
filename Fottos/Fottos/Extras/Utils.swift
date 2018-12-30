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
    static let total = "total"
    static let page = "page"
    
    struct QueryItems {
        static let method = "method"
        private init () {}
    }
    private init () {}
}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func dowloadFromServer(url: URL) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        let photo = PhotoDownload(url: url)
        photo.dowloadFromServer { (image, error) in
            if let image = image {
                DispatchQueue.main.async() {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    self.image = image
                }
            }
        }
    }
}

func asyncMain(_ block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

extension UICollectionViewCell {
    func addShadow() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = contentView.layer.cornerRadius
    }
}
