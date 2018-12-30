//
//  SearchViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

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

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
//        searchController.searchBar.sizeToFit()
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
        
//        if #available(iOS 11.0, *) {
//        } else {
//            // For iOS 10 and earlier, we place the search bar in the table view's header.
//            tableView.tableHeaderView = searchController.searchBar
//        }
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
            self.navigationItem.searchController?.searchBar.text = nil
            self.navigationItem.searchController?.searchBar.resignFirstResponder()
            createSearch(context: mainContext, title: searchText)
            performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.className, for: indexPath)
        cell.textLabel?.text = recentSearchTerms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchText = recentSearchTerms[indexPath.row]
        performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
    }
}


