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
    
    static func fetchAll(context: NSManagedObjectContext) -> [Favorite]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.className)
        do {
            let records = try context.fetch(fetchRequest) as? [Favorite]
            return records
        } catch let error as NSError {
            print(error.description)
        }
        return .none
    }
    
    static func addNew(context: NSManagedObjectContext, photo image: Photo) {
        Favorite.create(inContext: context) { favorite in
            favorite.url = image.url
        }
    }
    
    static func remove(context: NSManagedObjectContext, photoID: String) {
        
    }
}
