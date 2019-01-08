//
//  ExploreViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 1/3/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData

final class ExploreViewModel {
    
    // MARK: - Properties
    
    var context: NSManagedObjectContext?
    var categories = [Category]()
    
    init(context: NSManagedObjectContext?) {
        self.context = context
        self.categories = Config.shared.categories
    }
        
    var categoriesCount: Int {
        return categories.count
    }
    
    func categoryAtIndex(_ index: Int) -> Category {
        return categories[index]
    }
    
    func titleAtIndex(_ index: Int) -> String {
        return categories[index].title
    }
    
    func createSearch(context: NSManagedObjectContext?, title: String) {
        guard let context = context else { return }
        Search.addNew(context: context, title: title)
        Store.shareInstance?.saveContext()
    }
    
}
