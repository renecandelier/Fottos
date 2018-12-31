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
    
    var categories = ["Travel", "Cars", "Sneakers", "Food", "Sports", "Fashion", "Fitness", "Drinks", "Nature"]
    var mainContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        navigationController?.hideShadow()
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as! CategoryCollectionViewCell
        cell.imageView.image = UIImage(named: categories[indexPath.row])
        cell.titleLabel.text = categories[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: ThumbnailCollectionViewController.className, sender: self)
    }
    
    func createSearch(context: NSManagedObjectContext?, title: String) {
        guard let context = context else { return }
        Search.addNew(context: context, title: title)
        Store.shareInstance?.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            guard let thumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else { return }
            let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
            thumbnailCollectionViewController.searchText = categories[cellRow]
            createSearch(context: mainContext, title: categories[cellRow])
        }
    }
}

extension ExploreCollectionViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        //        guard let indexPath = collectionView?.indexPathForItem(at:location) else { return nil }
        //        guard  let cell2 = collectionView.cellForItem(at: indexPath) else { return nil }
        let thumnailPreview = ThumbnailCollectionViewController()
        
        let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
        thumnailPreview.searchText = categories[cellRow]
        return thumnailPreview
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}
