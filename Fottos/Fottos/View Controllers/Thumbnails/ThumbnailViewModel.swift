//
//  ThumbnailViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/28/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation

protocol ThumbnailViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: Error?)
    func reloadCollectionView()
}

final class ThumbnailViewModel {
    
    private var isFetchInProgress = false
    var photos: [Photo] = []
    private var searchText: String?
    private var currentPage = 1
    private var totalPhotos = 0
    
    private weak var delegate: ThumbnailViewModelDelegate?

    init(searchText: String?, delegate: ThumbnailViewModelDelegate?, photos: [Photo] = []) {
        
        self.photos = photos
        self.delegate = delegate
        self.searchText = searchText
        if searchText != nil {
            fetchImages()
        } else {
            loadPreloadedPhotos(photos)
        }
        
    }
    
    func loadPreloadedPhotos(_ photos: [Photo]) {
        self.totalPhotos = photos.count
        self.photos = photos
        self.delegate?.reloadCollectionView()
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    var totalCount: Int {
        return totalPhotos
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetchImages() {
        guard !isFetchInProgress, let searchText = searchText else { return }
        isFetchInProgress = true
        
        let photoSearch = PhotoSearch(searchTerm: searchText, page: currentPage, amountPerPage: 25)
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
                self.totalPhotos = pagedPhotoResponse.total
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
    
    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = photos.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
