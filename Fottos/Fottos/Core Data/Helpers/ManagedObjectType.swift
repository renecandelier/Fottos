//
//  ManagedObjectType.swift
//  Fottos
//
//  Created by Rene Candelier on 12/29/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectType: class {
    
}

extension ManagedObjectType where Self: NSManagedObject {

    @discardableResult static func create(inContext context: NSManagedObjectContext, configure: (Self) -> Void) -> Self {
        let createdObject: Self = context.insertObject()
        configure(createdObject)
        return createdObject
    }
    
    static func fetch(inContext context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> Void = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.className)
        configurationBlock(request)
        var result: [Self] = []
        context.performAndWait {
            guard let innerResult = try? context.fetch(request) as? [Self] else {
                print("Fetched Objects have the wrong type!")
                return
            }
            result = innerResult ?? []
        }
        return result
    }
}

extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A {
        return A(context: self)
    }
}
