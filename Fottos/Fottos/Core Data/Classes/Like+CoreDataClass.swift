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

public class Like: NSManagedObject, Photo, ManagedObjectType {
    
    static func fetchAll(context: NSManagedObjectContext) -> [Like]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Like")
        do {
            let records = try context.fetch(fetchRequest) as? [Like]
            return records
        } catch let error as NSError {
            print(error.description)
        }
        return .none
    }
    
    static func addNew(context: NSManagedObjectContext, photo image: Photo) {
        Like.create(inContext: context) { like in
            like.url = image.url
        }
    }
    
    static func remove(context: NSManagedObjectContext, photoID: String) {
        
    }
}
