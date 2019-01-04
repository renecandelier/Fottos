//
//  ThumbnailViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/28/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import UIKit

protocol ThumbnailViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: Error?)
    func reloadCollectionView()
    func reloadItems(_ indexPaths: [IndexPath])
}

final class ThumbnailViewModel {
    
    // MARK: - Constants
    
    let prefetchAmount = 10

    // MARK: - Properties
    
    private var isFetchInProgress = false
    var photos: [Photo] = []
    private var searchText: String?
    private var currentPage = 1
    var indexCache: [Int: UIImage] = [:]
    private weak var delegate: ThumbnailViewModelDelegate?

    init(searchText: String?, delegate: ThumbnailViewModelDelegate?, photos: [Photo] = []) {
        self.photos = photos
        self.delegate = delegate
        self.searchText = searchText
        loadPhotos(photos)
    }
    
    func loadPreloadedPhotos(_ photos: [Photo]?) {
        self.photos = photos ?? []
        self.delegate?.reloadCollectionView()
    }
    
    var currentCount: Int {
        // TODO: Handle scaffolding
//        if photos.count == 0 { return 10 }
        return photos.count
    }
    
    var startPrefetchAmount: Int {
        return currentCount - prefetchAmount
    }
    
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func photoUrl(at index: Int) -> String? {
        return photo(at: index).url
    }
    
    func loadPhotos(_ photos: [Photo]? = nil) {
        
        guard let photos = photos, !photos.isEmpty else {
            downloadPhotos()
            return
        }
        loadPreloadedPhotos(photos)
    }
    
    // TODO: Reduce
    func downloadPhotos() {
        
        guard !isFetchInProgress, let searchText = searchText else { return }
        
        isFetchInProgress = true
        
        let photoSearch = PhotoSearch(searchTerm: searchText, page: currentPage, amountPerPage: Config.shared.fetchPerPage)
        
        photoSearch.fetchPhotos { [weak self] (pagedPhotoResponse, error) in
            guard let self = self else { return }
            
            self.isFetchInProgress = false
            
            if error != nil {
                self.isFetchInProgress = false
                self.delegate?.onFetchFailed(with: error)
            }
            
            guard let pagedPhotoResponse = pagedPhotoResponse else { return }
            
            asyncMain {
                self.currentPage += 1
                self.isFetchInProgress = false
                let newPhotos = pagedPhotoResponse.photos
                self.photos.append(contentsOf: newPhotos)
                
                if pagedPhotoResponse.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: newPhotos)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
    
    func getImage(for indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            if let photoURL = photoUrl(at: indexPath.row), let url = URL(string: photoURL), url.isValid {
                fetchImage(url: url, indexPath: indexPath)
            }
        }
    }
    
    // TODO: SHOW error
    func fetchImage(url: URL, indexPath: IndexPath) {
        dowloadImage(url: url, indexPath: indexPath, completion: { (image, _) in
            asyncMain {
                if let image = image {
                    self.indexCache[indexPath.row] = image
                    self.delegate?.reloadItems([indexPath])
                }
            }
        })
    }
    
    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = photos.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        if currentCount < prefetchAmount { return false }
        return indexPath.row >= startPrefetchAmount
    }
}
