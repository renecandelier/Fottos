//
//  SettingsViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/31/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

protocol SettingsViewModelDelegate: class {
    
}

final class SettingsViewModel {
    
    weak var delegate: SettingsViewModelDelegate?
    
    init(delegate: SettingsViewModelDelegate) {
        self.delegate = delegate
    }
    
    var optionsCount: Int {
        return 1
    }
}
