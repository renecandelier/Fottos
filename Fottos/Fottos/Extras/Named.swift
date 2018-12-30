//
//  Utils.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

protocol Named {
    var className: String {get}
    static var className: String {get}
}

extension NSObject: Named {
    ///returns the class name
    var className: String {
        return type(of: self).className
    }
    ///returns the class name
    @nonobjc static var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}
