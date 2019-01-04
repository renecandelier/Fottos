//
//  SettingsViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/31/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SettingsViewModelDelegate: class {
    func presentAlert(_ alertController:UIAlertController)
}

final class SettingsViewModel {
    
    // MARK: - Properties
    
    weak var delegate: SettingsViewModelDelegate?
    var options = ["Fetch per page", "Remove all saved favorites", "Delete all recent search terms", "Clear Cache"]
    var context: NSManagedObjectContext?
    
    init(delegate: SettingsViewModelDelegate, context: NSManagedObjectContext?) {
        self.delegate = delegate
        self.context = context
    }
    
    var optionsCount: Int {
        return options.count
    }
    
    func textForIndex(_ index: Int) -> String {
        return options[index]
    }
    
    func clearPhotosCache() {
        imageCache.removeAllObjects()
        showCacheAlert()
    }
    
    func deleteRecentSearchTerms() {
        guard let context = context else { return }
        Search.removeAll(context: context)
        showRecentSearchAlert()
    }
    
    func removeAllFavorites() {
        guard let context = context else { return }
        Favorite.removeAll(context: context)
        showFavoritesAlert()
    }
    
    var perPageAmount: Int {
        switch FetchPerPage.getAmount() {
        case 50:
            return 1
        case 100:
            return 2
        default:
            return 0
        }
    }
    
    func savePerPageAmount(_ amount: Int) {
        FetchPerPage.save(amount)
    }
    // TODO: generic alert
    private func showCacheAlert() {
        let cacheAlert = getAlert(title: "Clear Cache", message: "All cache has been cleared", actionTitle: "OK")
        delegate?.presentAlert(cacheAlert)
    }
    
    private func showFavoritesAlert() {
        let favoritesAlert = getAlert(title: "Favorites", message: "All saved favorites have been removed", actionTitle: "OK")
        delegate?.presentAlert(favoritesAlert)
    }
    
    private func showRecentSearchAlert() {
        let recentSearchAlert = getAlert(title: "Recent Search Terms", message: "All saved search terms have been removed", actionTitle: "OK")
        delegate?.presentAlert(recentSearchAlert)
    }
    
    private func getAlert(title: String, message: String, actionTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(dismiss)
        return alert
    }
    
}
