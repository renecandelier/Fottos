//
//  Favorites.swift
//  Fottos
//
//  Created by Rene Candelier on 12/26/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

struct Favorites {
    
    private static let favorites = "Favorites"
    
    static func add(_ photo: PhotoStruct) {
        guard let photos = getAllFavorites() else {
            updateFavorites([photo])
            return
        }
        var favoritePhotos = photos
        favoritePhotos.append(photo)
        updateFavorites(favoritePhotos)
    }
    
    static func removePhoto(_ photo: PhotoStruct?) {
        guard let photo = photo, let photos = getAllFavorites() else { return }
        let favoritePhotos = photos.filter { $0.imageURL != photo.imageURL }
        updateFavorites(favoritePhotos)
    }
    
    static func getAllFavorites() -> [PhotoStruct]? {
        guard let favorites = UserDefaults.standard.array(forKey: Favorites.favorites) as? [PhotoStruct] else { return .none }
        return favorites
    }
    
    private static func updateFavorites(_ photos: [PhotoStruct]) {
        UserDefaults.standard.set(photos, forKey: Favorites.favorites)
    }
    
}
