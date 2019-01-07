//
//  SearchViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/31/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol SearchViewModelDelegate: class {
    func reloadRecentSearchTerms()
}

final class SearchViewModel {
    
    // MARK: - Constants

    let emptySearchTermsPlaceholder = "No Recent Searches 😞".localize

    // MARK: - Properties
    
    var searchTerms: SearchTerms = []
    var searchText = ""
    var filteredSearchTerms: SearchTerms = []
    
    private var mainContext: NSManagedObjectContext?
    private weak var delegate: SearchViewModelDelegate?

    init(delegate: SearchViewModelDelegate?, context: NSManagedObjectContext?) {
        self.delegate = delegate
        self.mainContext = context
    }
    
    var isSearchTermsEmpty: Bool {
        return searchTerms.count == 0
    }
    
    var searchTermsCount: Int {
        if isSearchTermsEmpty { return 1 }

        return searchTerms.count
    }
    
    func searchTerm(at index: Int, isFiltering: Bool = false) -> String {
        if isSearchTermsEmpty { return emptySearchTermsPlaceholder }
        return !isFiltering ? searchTerms[index] : filteredSearchTerms[index]
    }
    
    func updateCurrentSearchTerm(from index: Int) {
        searchText = searchTerm(at: index)
    }
    
    func updateRecentSearchTerms() {
        searchTerms = getRecentSearches()
        delegate?.reloadRecentSearchTerms()
    }
    
    func getRecentSearches() -> [String] {
        guard let context = mainContext else { return [] }
        return Search.fetchAll(context: context)
    }
    
    func saveRecentSearchTerm() {
        guard let context = mainContext else { return }
        Search.addNew(context: context, title: searchText)
        Store.shareInstance?.saveContext()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty { }
        filteredSearchTerms = searchTerms.filter { $0.contains(searchText)  }
        delegate?.reloadRecentSearchTerms()
    }
    
    func isFiltering(_ searchController: UISearchController) -> Bool {
        return searchController.isActive && !searchBarIsEmpty(searchController)
    }
    
    func searchBarIsEmpty(_ searchController: UISearchController) -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

}
