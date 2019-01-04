//
//  SettingsViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/30/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    var viewModel: SettingsViewModel!
    var context: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Store.shareInstance?.persistentContainer.viewContext
        viewModel = SettingsViewModel(delegate: self, context: context)
        navigationController?.hideShadow()
    }
    
    // MARK: - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount
    }
    // TODO: Clean
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.row == 0 {
             let fetchPerPageCell = tableView.dequeueReusableCell(withIdentifier: FetchPerPageUITableViewCell.className, for: indexPath) as! FetchPerPageUITableViewCell
            fetchPerPageCell.amountSegmentControl.selectedSegmentIndex = viewModel.perPageAmount
            cell = fetchPerPageCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath)
        }
        cell.textLabel?.text = viewModel.textForIndex(indexPath.row)

        return cell
    }
    
    @IBAction func amountSegmentControlSelected(_ sender: UISegmentedControl) {
        guard let titleAmount = sender.titleForSegment(at: sender.selectedSegmentIndex), let numberAmount = Int(titleAmount) else { return }
        viewModel.savePerPageAmount(numberAmount)
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            viewModel.removeAllFavorites()
        case 2:
            viewModel.deleteRecentSearchTerms()
        case 3:
            viewModel.clearPhotosCache()
        default:
            return
        }
    }
    
}

extension SettingsViewController : SettingsViewModelDelegate {
  
    func presentAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
    
}
