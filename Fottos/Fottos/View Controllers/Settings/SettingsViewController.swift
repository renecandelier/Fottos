//
//  SettingsViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/30/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewModelDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    var viewModel: SettingsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel(delegate: self)
        navigationController?.hideShadow()
    }
    
    // MARK: - Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath)
        cell.textLabel?.text = "Clear Cache"
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imageCache.removeAllObjects()
        showAlert()
    }

    func showAlert() {
        let alert = UIAlertController(title: "Cache", message: "All cache has been cleared.", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(dismiss)
        present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
