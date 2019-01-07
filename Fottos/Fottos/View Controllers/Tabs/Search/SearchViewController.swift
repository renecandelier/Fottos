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
    
    private let searchBarPlaceholder = "Food, Sneakers, Cats...".localize
    
    // MARK:- Properties

    var mainContext: NSManagedObjectContext?
    private var viewModel: SearchViewModel!
    var searchController: UISearchController!
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // MARK:- Outlets

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateRecentSearchTerms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = SearchViewModel(delegate: self, context: mainContext)
        viewModel.updateRecentSearchTerms()
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.hideShadow()
    }
    
    // MARK: - Search Bar
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        createSearchController()
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    fileprivate func createSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceholder
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterContentForSearchText(searchText)
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
        clearSearchBarText()
        dimissKeyboard()
    }
    
    func clearSearchBarText() {
        navigationItem.searchController?.searchBar.text = nil
    }
    
    func dimissKeyboard() {
        navigationItem.searchController?.searchBar.endEditing(true)
        navigationItem.searchController?.searchBar.showsCancelButton = false
    }
    
    // MARK: - SearchViewModelDelegate
    
    func reloadRecentSearchTerms() {
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            guard let thumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else { return }
            thumbnailCollectionViewController.searchText = viewModel.searchText
        }
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isFiltering(searchController) {
            return viewModel.filteredSearchTerms.count
        }
        return viewModel.searchTermsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath)
        cell.textLabel?.textColor = viewModel.isSearchTermsEmpty ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 0.1019607843, green: 0.7366531491, blue: 0.6107044816, alpha: 1)
        let isFiltering = viewModel.isFiltering(searchController)
        cell.textLabel?.text = viewModel.searchTerm(at: indexPath.row, isFiltering: isFiltering).localize
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateCurrentSearchTerm(from: indexPath.row)
        performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
    }
}


