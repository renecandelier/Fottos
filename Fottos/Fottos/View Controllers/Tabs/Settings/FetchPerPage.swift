//
//  Favorites.swift
//  Fottos
//
//  Created by Rene Candelier on 12/26/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

struct FetchPerPage {
    
    private static let fetchPerPage = "FetchPerPage"
    
    private init() { }
    
    static func save(_ amount: Int) {
        updateAmount(amount)
    }
    
    static func getAmount() -> Int {
        let amount = UserDefaults.standard.integer(forKey: fetchPerPage)
        guard amount != 0 else { return 25 }
        return amount
    }
    
    private static func updateAmount(_ amount: Int) {
        UserDefaults.standard.set(amount, forKey: fetchPerPage)
        UserDefaults.standard.synchronize()
    }
    
}
