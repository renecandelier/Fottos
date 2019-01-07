//
//  ExploreViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 1/3/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData

protocol ExploreViewModelDelegate: class, AlertPresentation {
    func reloadItems(_ indexPaths: [IndexPath]?, errorPresentation: ErrorPresentation?)
}

final class ExploreViewModel {
    
    // MARK: - Properties
    
    weak var delegate: ExploreViewModelDelegate?
    var context: NSManagedObjectContext?
    var indexImageCache = IndexPhotoCache()
    var categories = [Category]()
    
    init(delegate: ExploreViewModelDelegate?, context: NSManagedObjectContext?) {
        self.delegate = delegate
        self.context = context
        self.categories = Config.shared.categories
    }
    
    var categoriesCount: Int {
        return categories.count
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
    
    func categoryAtIndex(_ index: Int) -> Category {
        return categories[index]
    }
    
    func titleAtIndex(_ index: Int) -> String {
        return categories[index].title
    }
    
    func imageUrlAtIndex(_ index: Int) -> URL? {
        return URL(string: categoryAtIndex(index).image)
    }
    
    func createSearch(context: NSManagedObjectContext?, title: String) {
        guard let context = context else { return }
        Search.addNew(context: context, title: title)
        Store.shareInstance?.saveContext()
    }
    
}
