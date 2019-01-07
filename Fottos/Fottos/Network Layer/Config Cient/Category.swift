//
//  Category.swift
//  Fottos
//
//  Created by Rene Candelier on 1/2/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

struct Category {
    var title = ""
    var image = ""
    
    init(_ dictionary: CategoryDictionary) {
        parse(dictionary)
    }
    
    mutating func parse(_ dictionary: CategoryDictionary) {
        self.image = dictionary[ConfigKeys.image] ?? ""
        self.title = dictionary[ConfigKeys.title] ?? ""
    }
}
