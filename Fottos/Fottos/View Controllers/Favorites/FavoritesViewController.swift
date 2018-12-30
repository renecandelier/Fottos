//
//  FavoritesViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/23/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    var mainContext: NSManagedObjectContext?
    weak var thumbnailCollectionViewController: ThumbnailCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        if let photos = fetchFavoritePhoto() {
            thumbnailCollectionViewController?.viewModel.loadPreloadedPhotos(photos)
        }
    }
    
    func fetchFavoritePhoto() -> [Photo]? {
        guard let mainContext = mainContext else { return .none }
        return Like.fetchAll(context: mainContext)
    }
    
    override func viewWillAppear(_ animanted: Bool) {
        super.viewWillAppear(animanted)
        if let photos = fetchFavoritePhoto() {
            thumbnailCollectionViewController?.viewModel.loadPreloadedPhotos(photos)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ThumbnailCollectionViewController.className {
            guard let destinationThumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else {
                    // TODO: Handle no favorites
                    return
            }
            self.thumbnailCollectionViewController = destinationThumbnailCollectionViewController
            destinationThumbnailCollectionViewController.preLoadedPhotos = fetchFavoritePhoto()
        }
    }

}
