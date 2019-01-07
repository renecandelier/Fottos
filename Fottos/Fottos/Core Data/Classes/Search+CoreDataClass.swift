//
//  Search+CoreDataClass.swift
//  Fottos
//
//  Created by Rene Candelier on 12/29/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//
//

import Foundation
import CoreData

public class Search: NSManagedObject, ManagedObjectType {
    
    static func addNew(context: NSManagedObjectContext, title: String) {
        guard !fetchAll(context: context).contains(title) else { return }
        Search.create(inContext: context) { search in
            let savedDate = Date()
            search.title = title
            search.savedDate = savedDate
        }
    }
    
    static func fetchAll(context: NSManagedObjectContext) -> [String] {
        return fetch(inContext: context).compactMap { $0.title }
    }
    
    static func removeAll(context: NSManagedObjectContext) {
        let emptyPredicate = NSPredicate(value: true)
        deleteObjects(withPredicate: emptyPredicate, inContext: context, save: true)
    }
}
