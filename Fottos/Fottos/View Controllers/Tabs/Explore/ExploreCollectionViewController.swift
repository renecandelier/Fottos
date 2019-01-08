//
//  ExploreCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class ExploreCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var mainContext: NSManagedObjectContext?
    var viewModel: ExploreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = ExploreViewModel(context: mainContext)
        navigationController?.hideShadow()
        addInsets()
    }
    
    func addInsets() {
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    // MARK: - ExploreViewModelDelegate
    
    func presentAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categoriesCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as! CategoryCollectionViewCell
        
        let category = viewModel.categoryAtIndex(indexPath.row)
        cell.configure(category)
        cell.accessibilityIdentifier = "Category Cell \(indexPath.row)"
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            
            guard let thumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else { return }
            
            let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
            let categoryTitle = viewModel.titleAtIndex(cellRow)
            thumbnailCollectionViewController.searchText = categoryTitle
            viewModel.createSearch(context: mainContext, title: categoryTitle)
        }
    }
}
