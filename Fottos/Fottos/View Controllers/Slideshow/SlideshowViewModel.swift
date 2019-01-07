//
//  SlideshowViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/31/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol SlideshowViewModelDelegate: class, AlertPresentation {
    func reloadItems(_ indexPaths: [IndexPath]?, errorPresentation: ErrorPresentation?)
}

final class SlideshowViewModel {
    
    // MARK: - Properties
    
    weak var delegate: SlideshowViewModelDelegate?
    var context: NSManagedObjectContext?
    var photos: [Photo]?
    var currentPage = 0
    var indexImageCache = IndexPhotoCache()
    let collectionMargin = CGFloat(16)
    let itemSpacing = CGFloat(10)
    var itemHeight = CGFloat(322)
    var itemWidth = CGFloat(0)
    
    init(photos: [Photo]?, currentPage: Int, delegate: SlideshowViewModelDelegate?, context: NSManagedObjectContext?) {
        self.photos = photos
        self.currentPage = currentPage
        self.delegate = delegate
        self.context = context
    }
    
    func photoAtIndex(_ index: Int) -> Photo? {
        return photos?[index]
    }
    
    func savePhoto(_ photo: Photo?) {
        guard let photo = photo, let context = context else { return }
        Favorite.addNew(context: context, photo: photo)
        Store.shareInstance?.saveContext()
    }
    
    // MARK: - Image Download
    
    func getImage(for indexPath: IndexPath) {
        if let url = imageUrlAtIndex(indexPath.row), url.isValid {
            fetchImage(url: url, indexPath: indexPath)
        }
    }
    
    func fetchImage(url: URL, indexPath: IndexPath) {
        dowloadImage(url: url, indexPath: indexPath, completion: { (image, error) in
            asyncMain {
                
                if let error = error {
                    self.delegate?.reloadItems(.none, errorPresentation: self.delegate?.getErrorPresentation(error: error))
                    return
                }
                
                guard let image = image else { return }
                self.indexImageCache.saveImage(image: image, index: indexPath.row)
                self.delegate?.reloadItems([indexPath], errorPresentation: .none)
            }
        })
    }
    
    func imageUrlAtIndex(_ index: Int) -> URL? {
        guard let imageURL = photoAtIndex(index)?.url else { return .none }
        return URL(string: imageURL)
    }
    
    func slideshowCollectionViewFlowLayout(height colletionViewHeight: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        itemHeight = (colletionViewHeight - collectionMargin - itemWidth)
        layout.sectionInset = UIEdgeInsets(top: itemHeight/2, left: 0, bottom: itemHeight/2, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        return layout
    }
}
