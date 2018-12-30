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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
//        self.navigationController?.navigationBar.prefersLargeTitles = false
        viewModel = ThumbnailViewModel(searchText: searchText, delegate: self, photos: preLoadedPhotos ?? [])
        collectionView.prefetchDataSource = self
        setupCollectionView()
        setNavigationTitle(searchText)
        
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
    
    func updateCollectionView() {
       asyncMain {
            self.collectionView.reloadData()
        }
    }
    
    func reloadContent() {
         updateCollectionView()
    }
    
    // MARK: Prefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: isLoadingCell), let searchText = searchText {
//            DispatchQueue.global(qos: .background).async {
                self.viewModel.fetchImages(searchTerm: searchText)
//            }
        }
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
//            indicatorView.stopAnimating()
//            tableView.isHidden = false
            updateCollectionView()
            return
        }
        
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        collectionView.reloadItems(at: newIndexPathsToReload)
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

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.photo(at: indexPath.row))
        }

        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
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
        return indexPaths
    }
}
