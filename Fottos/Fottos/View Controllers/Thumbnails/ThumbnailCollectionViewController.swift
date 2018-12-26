//
//  ThumbnailCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/23/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CategoryCollectionViewCell"

class ThumbnailCollectionViewController: UICollectionViewController {

    var photos = [Photo]()
    var selectedPhoto: Photo?
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 20.0, right: 8.0)
        
        setupCollectionView()
        
//        if let searchText = searchText {
//            fetchImages(searchTerm: searchText)
//        }
        fetchImages(searchTerm: searchText ?? "car")

        setNavigationTitle(searchText)
    }
    
    func setupCollectionView() {
        let flow = collectionViewLayout as! UICollectionViewFlowLayout
        
        let itemSpacing: CGFloat = 2
        let itemsInOneLine: CGFloat = 2
        
        flow.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 2)
        
        flow.itemSize = CGSize(width: floor(width/2.2), height: width/2.2)
        flow.minimumInteritemSpacing = 2
        flow.minimumLineSpacing = 20
    }
    
    func setNavigationTitle(_ title: String?) {
        navigationItem.title = title
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
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        if let url = photos[indexPath.row].imageURL, let imageView = cell.imageView {
            imageView.dowloadFromServer(url: url)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = photos[indexPath.row]

        performSegue(withIdentifier: "DetailViewController", sender: self)
    }
    
    // MARK: - Navigation
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            if let detailViewController = segue.destination as? DetailViewController {
                let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
                detailViewController.currentPage = cellRow
                detailViewController.photos = photos
            }
        }
    }

}
