//
//  SearchViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

extension UINavigationController {
    func hideShadow() {
        self.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var recentSearchTerms = [String]()
    
    var searchText = ""
    var mainContext: NSManagedObjectContext?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRecentSearchTerms()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRecentSearchTerms()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        setupSearchBar()
    }
    
    // MARK: Search Bar
    
    fileprivate func setupSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.hideShadow()
        definesPresentationContext = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Food, Sneakers, Cats..."
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    func updateRecentSearchTerms() {
        recentSearchTerms = getRecentSearches()
        tableView.reloadData()
    }
    
    func getRecentSearches() -> [String] {
        guard let context = mainContext else { return [] }
        return Search.fetchAll(context: context)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text ?? ""
        if !searchText.isEmpty {
            resetSearchBar(searchBar)
            createSearch(context: mainContext, title: searchText)
            performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
        }
    }
    
    func resetSearchBar(_ searchBar: UISearchBar) {
        navigationItem.searchController?.searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            guard let thumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else { return }
            thumbnailCollectionViewController.searchText = searchText
        }
    }
    
    func createSearch(context: NSManagedObjectContext?, title: String) {
        guard let context = context else { return }
        Search.addNew(context: context, title: title)
        Store.shareInstance?.saveContext()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchTerms.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath)
        cell.textLabel?.textColor = #colorLiteral(red: 0.1019607843, green: 0.7366531491, blue: 0.6107044816, alpha: 1)
        cell.textLabel?.text = recentSearchTerms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchText = recentSearchTerms[indexPath.row]
        performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
    }
}


