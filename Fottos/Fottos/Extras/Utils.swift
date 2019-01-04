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
        static let apiKey = "api_key"
        static let jsonCallback = "nojsoncallback"
        static let format = "format"
        static let perPage = "per_page"
        static let text = "text"
        static let contentType = "content_type"
        static let media = "media"
        private init () {}
    }
    private init () {}
}

var appVersionNumber: String {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}


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

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func dowloadFromServer(url: URL, indexPath: IndexPath? = nil, completion:  @escaping (UIImage?, Error?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            asyncMain {
                completion(cachedImage, nil)
            }
            return
        }
        
        DownloadImage(url: url).dowloadFromServer { (image, error) in
            if let error = error {
                completion(nil, error)
            }
            if let image = image {
                asyncMain() {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                }
            }
        }
    }
}

func dowloadImage(url: URL, indexPath: IndexPath? = nil, completion:  @escaping (UIImage?, Error?) -> Void) {
    
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
        asyncMain {
            completion(cachedImage, nil)
        }
        return
    }
    
    DownloadImage(url: url).dowloadFromServer { (image, error) in
        if let error = error {
            completion(nil, error)
        }
        if let image = image {
            asyncMain() {
                imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image, nil)
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
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = contentView.layer.cornerRadius
    }
    
    func addRoundCorners() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}

extension UINavigationController {
    func hideShadow() {
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}

extension String {
    var bundleValue: String? {
        let value = Bundle.main.object(forInfoDictionaryKey: self) as? String
        return (value?.isEmpty == false) ? value : nil
    }
}

extension Dictionary {
    mutating func combine(_ other: Dictionary) {
        for (key, value) in other {
            updateValue(value, forKey: key)
        }
    }
}

var applicationDocumentsDirectory: URL {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
}
