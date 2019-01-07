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
    let activitySpinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = ExploreViewModel(delegate: self, context: mainContext)
        navigationController?.hideShadow()
        addInsets()
        addActivityIndicator()
    }

    func addInsets() {
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func addActivityIndicator() {
        view.addSubview(activitySpinner)
        activitySpinner.center = view.center
        activitySpinner.startAnimating()
        activitySpinner.hidesWhenStopped = true
    }
    
    func stopActivityIndicator() {
        activitySpinner.stopAnimating()
    }
    
    // MARK: - ExploreViewModelDelegate
    
    func reloadItems(_ indexPaths: [IndexPath]?, errorPresentation: ErrorPresentation?) {
        stopActivityIndicator()
        if let errorAlert = errorPresentation?.alert  {
            presentAlert(errorAlert)
            return
        }
        
        guard let indexPaths = indexPaths else { return }
        collectionView.reloadItems(at: indexPaths)
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
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
        
        cell.titleLabel.text? = category.title.localize
        guard let imageDownloaded = viewModel.indexImageCache.image(at: indexPath.row) else {
            viewModel.getImage(for: indexPath)
            return cell
        }
        cell.imageView.image = imageDownloaded
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
