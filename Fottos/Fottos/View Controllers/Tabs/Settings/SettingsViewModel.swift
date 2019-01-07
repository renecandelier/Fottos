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

protocol AlertPresentation {
    func presentAlert(_ alertController:UIAlertController)
}

extension AlertPresentation {
    
    func getAlertController(title: String, message: String, actionTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(dismiss)
        return alert
    }
    
    func getErrorPresentation(error: Error) -> ErrorPresentation {
        return ErrorPresentation(error: error, alert: getErrorAlert(from: error))
    }
    
    func getErrorAlert(from error: Error) -> ErrorAlert {
        let errorAlert = getAlertController(title: "Error", message: error.localizedDescription, actionTitle: "OK")
        return errorAlert
    }
}

protocol SettingsViewModelDelegate: class, AlertPresentation {

}

final class SettingsViewModel: AlertPresentation {
    
    // MARK: - Properties
    
    weak var delegate: SettingsViewModelDelegate?
    var options = ["Fetch per page",
                   "Remove all saved favorites",
                   "Delete all recent search terms",
                   "Clear Cache"].localize
    
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
    
    func getFetchPerPageCell(tableView: UITableView, indexPath: IndexPath) -> FetchPerPageUITableViewCell {
        let fetchPerPageCell = tableView.dequeueReusableCell(withIdentifier: FetchPerPageUITableViewCell.className, for: indexPath) as! FetchPerPageUITableViewCell
        fetchPerPageCell.amountSegmentControl.selectedSegmentIndex = perPageAmount
        return fetchPerPageCell
    }
    
    // MARK: Alerts
    
    private func showCacheAlert() {
        let cacheAlert = getAlertController(title: "Clear Cache".localize, message: "All cache has been cleared".localize, actionTitle: "OK".localize)
        presentAlert(cacheAlert)
    }
    
    private func showFavoritesAlert() {
        let favoritesAlert = getAlertController(title: "Favorites".localize, message: "All saved favorites have been removed".localize, actionTitle: "OK".localize)
        presentAlert(favoritesAlert)
    }
    
    private func showRecentSearchAlert() {
        let recentSearchAlert = getAlertController(title: "Recent Search Terms".localize, message: "All saved search terms have been removed".localize, actionTitle: "OK".localize)
        presentAlert(recentSearchAlert)
    }
    
    func presentAlert(_ alert: UIAlertController) {
        delegate?.presentAlert(alert)
    }
    
}
