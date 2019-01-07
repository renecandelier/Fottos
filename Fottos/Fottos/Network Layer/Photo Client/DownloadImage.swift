//
//  PhotoDownload.swift
//  Fottos
//
//  Created by Rene Candelier on 12/22/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import UIKit

protocol Photo {
    var url: String? { get }
    var title: String? { get set }
}

struct DownloadImage: RequestType {
    
    private let imagePrefix = "image"
    let url: URL

    var requestData: RequestData? {
        return RequestData(url: url, dataType: .Data)
    }
    
    func dowloadFromServer(completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        guard url.isValid else { return }
        
        execute { (_, data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            guard let isImageType = response?.mimeType?.hasPrefix(self.imagePrefix), isImageType, let data = data, let image = UIImage(data: data) else {
                
                completionHandler(nil, ApiError.imageFailed)
                
                return
            }
            DispatchQueue.main.async() {
                completionHandler(image, nil)
            }
        }
    }
}
