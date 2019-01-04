//
//  FavoritesViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/31/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData

protocol FavoritesViewModelDelegate: class {
    func updateThumnails(photos: [Photo]?)
}

final class FavoritesViewModel {
    
    // MARK: - Properties

    var mainContext: NSManagedObjectContext?
    weak var delegate: FavoritesViewModelDelegate?
    
    // MARK: - Constants
    
    let emptySearchTermsPlaceholder = "No photos saved to your favorites 😞"

    init(delegate: FavoritesViewModelDelegate?, context: NSManagedObjectContext?) {
        self.delegate = delegate
        self.mainContext = context
    }
    
    var favoritePhotos: [Photo]? {
        return fetchFavoritePhotos()
    }
    
    private func fetchFavoritePhotos() -> [Photo]? {
        guard let context = mainContext else { return .none }
        
        return Favorite.fetchAll(context: context)
    }
    
    func updateThumbnails() {
        delegate?.updateThumnails(photos: fetchFavoritePhotos())
    }
}
