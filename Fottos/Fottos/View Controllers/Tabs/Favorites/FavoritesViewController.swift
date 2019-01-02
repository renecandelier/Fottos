//
//  FavoritesViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/23/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, FavoritesViewModelDelegate {

    // MARK:- Outlets
    
    @IBOutlet weak var emptyFavoritresLabel: UILabel!
    
    // MARK:- Properties

    var mainContext: NSManagedObjectContext?
    weak var thumbnailCollectionViewController: ThumbnailCollectionViewController?
    var viewModel: FavoritesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        createViewModel()
        viewModel?.updateThumbnails()
        navigationController?.hideShadow()
    }
    
    func createViewModel() {
        viewModel = FavoritesViewModel(delegate: self, context: mainContext)
    }
    
    override func viewWillAppear(_ animanted: Bool) {
        super.viewWillAppear(animanted)
        viewModel?.updateThumbnails()
    }
    
    // MARK: - FavoritesViewModelDelegate
    
    func updateThumnails(photos: [Photo]?) {
        thumbnailCollectionViewController?.viewModel.loadPreloadedPhotos(photos)
        updateEmptyFavoritesLabel()
    }
    
    func updateEmptyFavoritesLabel() {
        thumbnailCollectionViewController?.reloadCollectionView()
        emptyFavoritresLabel.isHidden = !(viewModel?.favoritePhotos?.isEmpty ?? false)
        emptyFavoritresLabel.text = viewModel?.emptySearchTermsPlaceholder ?? ""
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            
            guard let destinationThumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else {
                    return
            }
            
            self.thumbnailCollectionViewController = destinationThumbnailCollectionViewController
            destinationThumbnailCollectionViewController.preLoadedPhotos = viewModel?.favoritePhotos
        }
    }

}
