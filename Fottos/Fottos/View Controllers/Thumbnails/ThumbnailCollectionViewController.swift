//
//  ThumbnailCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/23/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit


class ThumbnailCollectionViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching, ThumbnailViewModelDelegate {
    
    var viewModel: ThumbnailViewModel!
    var searchText: String?
    var preLoadedPhotos: [Photo]?
    var indexCache: [Int: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ThumbnailViewModel(searchText: searchText, delegate: self, photos: preLoadedPhotos ?? [])
        collectionView.prefetchDataSource = self
        setupCollectionView()
        setNavigationTitle(searchText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indexCache.removeAll()
    }
    
    func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 20.0, right: 8.0)

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
    
    func reloadCollectionView() {
        asyncMain {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Prefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.loadPhotos()
        }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
//        guard let newIndexPathsToReload = newIndexPathsToReload else {
//            return
//        }
        reloadCollectionView()

    }
    
    func onFetchFailed(with reason: Error?) {
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.className, for: indexPath) as! CategoryCollectionViewCell
        
        
        //        if isLoadingCell(for: indexPath) {
        //            cell.configure(with: .none)
        //        } else {
        //                cell.configure(with: self.viewModel.photo(at: indexPath.row))

        
        if let imageDownloaded = indexCache[indexPath.row] {
            cell.imageView.image = imageDownloaded
        } else {
            if !isLoadingCell(for: indexPath) {
                if let photoURL = viewModel.photo(at: indexPath.row).url, let url = URL(string: photoURL), url.isValid {
                    
                    cell.imageView.dowloadFromServer(url: url, indexPath: indexPath, completion: { (image, _) in
                        asyncMain {
                            
                            if let image = image {
                                if let updateCell = self.collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
                                    
                                    updateCell.imageView?.image = image
                                    //                                    cell.configure(with: self.viewModel.photo(at: indexPath.row))
                                    
                                } else {
                                    //                                self.reloadCollectionView()
                                    
                                    
                                    print("not showing image at \(indexPath.row)")
                                }
                                self.indexCache[indexPath.row] = image
                                
                            }
                        }
                    })
                    
                }
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: DetailViewController.className, sender: self)
    }
    
    // MARK: - Navigation
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DetailViewController.className {
            if let detailViewController = segue.destination as? DetailViewController {
                let cellRow = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
                detailViewController.currentPage = cellRow
                detailViewController.photos = viewModel.photos
            }
        }
    }

}

private extension ThumbnailCollectionViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
