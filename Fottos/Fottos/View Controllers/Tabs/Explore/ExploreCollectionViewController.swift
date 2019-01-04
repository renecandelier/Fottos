//
//  ExploreCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class ExploreCollectionViewController: UICollectionViewController, ExploreViewModelDelegate {
    
    // MARK: - Properties
    
    var mainContext: NSManagedObjectContext?
    var viewModel: ExploreViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = ExploreViewModel(delegate: self, context: mainContext)
        navigationController?.hideShadow()
        addInsets()
    }

    func addInsets() {
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func categoriesUpdated() {
        updateCollectionView()
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as! CategoryCollectionViewCell
        let category = viewModel.categoryAtIndex(indexPath.row)
        // TODO: Move this to VM
        if let url = URL(string: category.image),
            url.isValid {
            cell.imageView.dowloadFromServer(url: url) { (image, _) in
                asyncMain {
                    if let image = image {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        cell.titleLabel.text = category.title
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

extension ExploreCollectionViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        // TODO: Finish Peeking with Save or Share options
        
        //        guard let indexPath = collectionView?.indexPathForItem(at:location) else { return nil }
        //        guard  let cell2 = collectionView.cellForItem(at: indexPath) else { return nil }
        let thumnailPreview = ThumbnailCollectionViewController()
        
        let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
        thumnailPreview.searchText = viewModel.titleAtIndex(cellRow)
        return thumnailPreview
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}
