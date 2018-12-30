//
//  Photo.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData

enum StoreError: Error {
    case initError(error: String)
}

class Store {
    
    public static let shareInstance = Store.instance(modelName: "Fottos")
    
    public let mainContext: NSManagedObjectContext!
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    public init?(modelURL: URL) {
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            mainContext = nil
            print("🚨 Model Creation Error")
            return nil
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        } catch let error as NSError {
            print("🚨model creation error \(error.description)")
        }
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = coordinator
        mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        persistentStoreCoordinator = coordinator
    }
    
    private static func instance(modelName: String) -> Store? {
        do {
            return try store(modelName: modelName)
        } catch let error as NSError {
            print("🚨 Core Data Creation error: \(error.description)")
            return nil
        }
    }
    
    private static func store(modelName: String) throws -> Store {
        let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")
        guard let model = modelURL, let store = Store(modelURL: model) else {
            throw StoreError.initError(error:"🚨 model url nil")
        }
        return store
    }
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Fottos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
