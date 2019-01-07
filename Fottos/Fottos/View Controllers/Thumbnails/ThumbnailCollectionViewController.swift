//
//  ThumbnailCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/23/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit


class ThumbnailCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var viewModel: ThumbnailViewModel!
    var searchText: String?
    var preLoadedPhotos: [Photo]?
    let activitySpinner = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ThumbnailViewModel(searchText: searchText, delegate: self, photos: preLoadedPhotos ?? [])
        collectionView.prefetchDataSource = self
        setCollectionViewInsets()
        setupCollectionViewLayout()
        setNavigationTitle(searchText)
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.indexImageCache.clearCache()
    }
    
    func setCollectionViewInsets() {
        collectionView.contentInset = UIEdgeInsets(top: 20.0, left: 8.0, bottom: 20.0, right: 8.0)
    }
    
    func setupCollectionViewLayout() {
        collectionView.collectionViewLayout = viewModel.getFlowLayout()
    }
    
    func setNavigationTitle(_ title: String?) {
        navigationItem.title = title
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
    
    func reloadCollectionView() {
        asyncMain {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
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

extension ThumbnailCollectionViewController: ThumbnailViewModelDelegate {
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        stopActivityIndicator()
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            reloadCollectionView()
            return
        }
        collectionView?.insertItems(at: newIndexPathsToReload)
    }
    
    func reloadItems(_ indexPaths: [IndexPath]?, errorPresentation: ErrorPresentation?) {
        
        if let errorAlert = errorPresentation?.alert  {
            presentAlert(errorAlert)
            return
        }
        
        guard let indexPaths = indexPaths else { return }
        collectionView.reloadItems(at: indexPaths)
    }
    
    func onFetchFailed(errorPresentation: ErrorPresentation?) {
        stopActivityIndicator()
        guard let errorAlert = errorPresentation?.alert else { return }
        presentAlert(errorAlert)
    }
    
    func presentAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
}

extension ThumbnailCollectionViewController {
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.className, for: indexPath) as! ThumbnailCollectionViewCell
        
        guard let cachedImage = viewModel.indexImageCache.image(at: indexPath.row) else {
            viewModel.getImage(for: indexPath)
            return cell
        }
        cell.imageView.image = cachedImage
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.currentCount > 0 else { return }
        performSegue(withIdentifier: DetailViewController.className, sender: self)
    }
    
}

extension ThumbnailCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    // MARK: - Prefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: viewModel.isLoadingCell) {
            viewModel.loadPhotos()
        }
    }
}
