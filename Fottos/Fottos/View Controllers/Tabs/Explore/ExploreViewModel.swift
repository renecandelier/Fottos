//
//  ExploreViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 1/3/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData

protocol ExploreViewModelDelegate: class {
    func categoriesUpdated()
}

final class ExploreViewModel {
    
    // MARK: - Properties
    
    weak var delegate: ExploreViewModelDelegate?
    var context: NSManagedObjectContext?
    var categories: [Category] = [] {
        didSet {
            delegate?.categoriesUpdated()
        }
    }
    
    init(delegate: ExploreViewModelDelegate?, context: NSManagedObjectContext?) {
        self.delegate = delegate
        self.context = context
        fetchConfig()
    }
    
    func categoryAtIndex(_ index: Int) -> Category {
        return categories[index]
    }
    
    func titleAtIndex(_ index: Int) -> String {
        return categories[index].title
    }
    
    func fetchConfig() {
        FectConfigFeed().fetchConfig { (json, error) in
            asyncMain {
                self.categories = Config.shared.categories
            }
        }
    }
    
    func createSearch(context: NSManagedObjectContext?, title: String) {
        guard let context = context else { return }
        Search.addNew(context: context, title: title)
        Store.shareInstance?.saveContext()
    }
    
}
