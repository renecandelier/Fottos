//
//  SearchViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, SearchViewModelDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK:- Constants
    
    private let searchBarPlaceholder = "Food, Sneakers, Cats..."
    
    // MARK:- Properties

    var mainContext: NSManagedObjectContext?
    private var viewModel: SearchViewModel!
    
    // MARK:- Outlets

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateRecentSearchTerms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = SearchViewModel(delegate: self, context: mainContext)
        viewModel.updateRecentSearchTerms()
        setupSearchBar()
    }
    
    // MARK:- Search Bar
    
    fileprivate func setupSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.hideShadow()
        definesPresentationContext = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceholder
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = searchBar.text ?? ""
        if !viewModel.searchText.isEmpty {
            resetSearchBar(searchBar)
            viewModel.saveRecentSearchTerm()
            performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
        }
    }
    
    func resetSearchBar(_ searchBar: UISearchBar) {
        navigationItem.searchController?.searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    // MARK:- SearchViewModelDelegate
    
    func reloadRecentSearchTerms() {
        tableView.reloadData()
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            guard let thumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else { return }
            thumbnailCollectionViewController.searchText = viewModel.searchText
        }
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchTermsCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath)
        cell.textLabel?.textColor = viewModel.isSearchTermsEmpty ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.1019607843, green: 0.7366531491, blue: 0.6107044816, alpha: 1)
        cell.textLabel?.text = viewModel.searchTerm(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateCurrentSearchTerm(from: indexPath.row)
        performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
    }
}


