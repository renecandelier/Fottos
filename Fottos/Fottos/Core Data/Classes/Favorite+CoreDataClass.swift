//
//  Like+CoreDataClass.swift
//  Fottos
//
//  Created by Rene Candelier on 12/27/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//
//

import Foundation
import CoreData

public class Favorite: NSManagedObject, Photo, ManagedObjectType {
    
    static func defaultPredicate(usingIdentifier identifier: String) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", identifier)
    }
    
    static func fetchAll(context: NSManagedObjectContext) -> [Photo] {
        return fetch(inContext: context)
    }
    
    static func addNew(context: NSManagedObjectContext, photo image: Photo) {

        guard !isPhotoSaved(context: context, photo: image) else {
            remove(context: context, url: image.url)
            return
        }

        Favorite.create(inContext: context) { favorite in
            let savedDate = Date()

            favorite.url = image.url
            favorite.title = image.title
            favorite.savedDate = savedDate
        }
    }
    
    static func isPhotoSaved(context: NSManagedObjectContext, photo: Photo) -> Bool {
        guard let url = photo.url, Favorite.getPhoto(context: context, url: url) != nil else { return false }
        
        return true
    }
    
    static func removeAll(context: NSManagedObjectContext) {
        let emptyPredicate = NSPredicate(value: true)
        deleteObjects(withPredicate: emptyPredicate, inContext: context, save: true)
    }
    
    private static func getPhoto(context: NSManagedObjectContext, url: String) -> Photo? {
        let allSavedPhotos = Favorite.fetchAll(context: context)
        return allSavedPhotos.filter { $0.url == url }.first
    }
    
    private static func remove(context: NSManagedObjectContext, url: String?) {
        guard let url = url, let photo = getPhoto(context: context, url: url) as? Favorite else { return }
        context.delete(photo)
    }
}
