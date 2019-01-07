//
//  ThumbnailViewModel.swift
//  Fottos
//
//  Created by Rene Candelier on 12/28/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import Foundation
import UIKit

struct ErrorPresentation {
    var error: Error?
    var alert: ErrorAlert?
}

protocol ThumbnailViewModelDelegate: class, AlertPresentation {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(errorPresentation: ErrorPresentation?)
    func reloadCollectionView()
    func reloadItems(_ indexPaths: [IndexPath]?, errorPresentation: ErrorPresentation?)
}

struct IndexPhotoCache {
    
    private var indexCache = [Int: UIImage]()
    
    func image(at index: Int) -> UIImage? {
        return indexCache[index]
    }
    
    mutating func saveImage(image: UIImage, index: Int) {
        indexCache[index] = image
    }
    
    mutating func clearCache() {
       indexCache.removeAll()
    }
}

final class ThumbnailViewModel: AlertPresentation {
    
    // MARK: - Constants
    
    let prefetchAmount = 10

    // MARK: - Properties
    
    private weak var delegate: ThumbnailViewModelDelegate?
    var isFetchInProgress = false
    private var searchText: String?
    private var currentPage = 1
    var photos = [Photo]()
    var indexImageCache = IndexPhotoCache()
    
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
    
    func updateFetchIsInProgress() {
        isFetchInProgress = !isFetchInProgress
    }
    
    var currentCount: Int {
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
    
    private func incrementCurrentPage() {
        currentPage += 1
    }
    
    func downloadPhotos() {
        
        guard !isFetchInProgress, let searchText = searchText else { return }
        
        updateFetchIsInProgress()
        
        let photoSearch = PhotoSearch(searchTerm: searchText, page: currentPage, amountPerPage: Config.shared.fetchPerPage)
        
        photoSearch.fetchPhotos { [weak self] (pagedPhotoResponse, error) in
            guard let self = self else { return }
            
            self.updateFetchIsInProgress()
            
            if let error = error {
                self.delegate?.onFetchFailed(errorPresentation: self.getErrorPresentation(error: error))
                return
            }
            
            guard let pagedPhotoResponse = pagedPhotoResponse else { return }
            asyncMain {
                self.incrementCurrentPage()
                self.showNewPhotos(pagedPhotoResponse: pagedPhotoResponse)
            }
        }
    }
    
    func addNewPhotos(_ newPhotos: [Photo]) {
        photos.append(contentsOf: newPhotos)
    }
    
    func showNewPhotos(pagedPhotoResponse: PagedPhotoResponse) {
        let newPhotos = pagedPhotoResponse.photos
        addNewPhotos(newPhotos)
        if pagedPhotoResponse.page > 1 {
            let indexPathsToReload = calculateIndexPathsToReload(from: newPhotos)
            delegate?.onFetchCompleted(with: indexPathsToReload)
        } else {
            delegate?.onFetchCompleted(with: .none)
        }
    }
    
    func getImage(for indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            if let photoURL = photoUrl(at: indexPath.row), let url = URL(string: photoURL), url.isValid {
                fetchImage(url: url, indexPath: indexPath)
            }
        }
    }
    
    func fetchImage(url: URL, indexPath: IndexPath) {
        dowloadImage(url: url, indexPath: indexPath, completion: { (image, error) in
            asyncMain {
                
                if let error = error {
                    self.delegate?.reloadItems(.none, errorPresentation: self.getErrorPresentation(error: error))
                    return
                }
                
                guard let image = image else { return }
                self.indexImageCache.saveImage(image: image, index: indexPath.row)
                self.delegate?.reloadItems([indexPath], errorPresentation: .none)
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

    func getFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let itemSpacing: CGFloat = 2
        let itemsInOneLine: CGFloat = 2
        
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 2)
        
        flowLayout.itemSize = CGSize(width: floor(width/2.2), height: width/2.2)
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 20
        return flowLayout
    }
    
    func presentAlert(_ alertController: UIAlertController) {
        
    }
}
