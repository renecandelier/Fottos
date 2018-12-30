//
//  Like+CoreDataProperties.swift
//  Fottos
//
//  Created by Rene Candelier on 12/27/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//
//

import Foundation
import CoreData


extension Like {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Like> {
        return NSFetchRequest<Like>(entityName: "Like")
    }

    @NSManaged public var url: String?

}
