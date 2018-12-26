//
//  ExploreCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCollectionViewCell"

class ExploreCollectionViewController: UICollectionViewController {

    var photos = [Photo]()
    
    var categories = ["Cars", "Food", "Sports", "Fashion"]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 0.0, right: 8.0)
        fetchImages(searchTerm: "car")
    }

    func fetchImages(searchTerm: String) {
        let photoSearch = PhotoSearch(searchTerm: searchTerm, page: 1, amountPerPage: 25)
        photoSearch.fetchPhotos { [weak self] (newPhotos, error) in
            if error != nil {
                // TODO: Handle error
            }
            
            guard let self = self else { return }
            guard let newPhotos = newPhotos else { return }
            
            self.photos += newPhotos
            self.updateCollectionView()
        }
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
//            self.collectionView.setContentOffset(CGPoint(x: 0, y: -56), animated: false)
        }
    }    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
//        if let url = photos[indexPath.row].imageURL, let imageView = cell.imageView {
//            imageView.dowloadFromServer(url: url)
//        }
        cell.imageView.image = UIImage(named: categories[indexPath.row])
        cell.titleLabel.text = categories[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThumbnailCollectionViewController" {
            guard let thumbnailCollectionViewController = segue.destination as? ThumbnailCollectionViewController else { return }
            let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
            thumbnailCollectionViewController.searchText = categories[cellRow]
        }
    }
}
