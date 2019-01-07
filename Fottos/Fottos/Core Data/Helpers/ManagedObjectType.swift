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
    
    static var sortDate: [NSSortDescriptor] {
        let sectionSortDescriptor = NSSortDescriptor(key: "savedDate", ascending: false)
        return [sectionSortDescriptor]
    }
    
    @discardableResult static func create(inContext context: NSManagedObjectContext, configure: (Self) -> Void) -> Self {
        let createdObject: Self = context.insertObject()
        configure(createdObject)
        return createdObject
    }
    
    static func fetch(inContext context: NSManagedObjectContext, isSorted: Bool = true, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> Void = { _ in }) -> [Self] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.className)
        if isSorted {
            request.sortDescriptors = sortDate
        }
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
    
    static func deleteObjects(withPredicate predicate: NSPredicate, inContext context: NSManagedObjectContext, save: Bool) {
        let objectsToDelete = fetch(inContext: context, configurationBlock: { (request) in
            request.predicate = predicate
        })
        if objectsToDelete.count > 0 {
            context.performChangesAndWait(save: save, block: {
                context.deleteObjects(setOfObjects: NSSet(array: objectsToDelete))
            })
        }
    }
}

extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A {
        return A(context: self)
    }
    
    func deleteObjects(setOfObjects set: NSSet?) {
        guard let set = set else { return }
        for object in set {
            switch object {
            case let managedObject as NSManagedObject:
                self.delete(managedObject)
            default:
                fatalError("I'm trying to delete a non managed object!")
            }
        }
    }
    
    func performChangesAndWait(save shouldSave: Bool, block: @escaping () -> Void) {
        performAndWait {
            block()
            if shouldSave {
                self.saveOrRollback()
            }
        }
    }
    
    @discardableResult func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
}
