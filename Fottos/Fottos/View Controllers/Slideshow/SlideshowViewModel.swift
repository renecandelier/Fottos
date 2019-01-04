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

// TODO: is needed?
protocol SlideshowViewModelDelegate: class {
    
}

final class SlideshowViewModel {
    
    // MARK: - Properties
    
    weak var delegate: SlideshowViewModelDelegate?
    var context: NSManagedObjectContext?
    var photos: [Photo]?
    var currentPage = 0
    
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
}
