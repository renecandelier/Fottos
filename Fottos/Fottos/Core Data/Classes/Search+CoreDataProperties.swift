//
//  Search+CoreDataProperties.swift
//  Fottos
//
//  Created by Rene Candelier on 12/29/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var title: String?

}
