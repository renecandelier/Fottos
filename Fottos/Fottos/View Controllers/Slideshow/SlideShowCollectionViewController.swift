//
//  SlideshowCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/20/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class SlideshowCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, SlideshowViewModelDelegate {
    
    // MARK: - Properties
    
    var mainContext: NSManagedObjectContext?
    var viewModel: SlideshowViewModel!
    var currentPage = 0
    var photos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = SlideshowViewModel(photos: photos, currentPage: currentPage, delegate: self, context: mainContext)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCollectionViewLayout()
        scrollToItem(viewModel?.currentPage ?? 0)
    }
    
    func setCollectionViewLayout() {
        collectionView?.collectionViewLayout = viewModel.slideshowCollectionViewFlowLayout(height: collectionView.bounds.height)
        collectionView?.decelerationRate = .fast
    }
    
    func scrollToItem(_ item: Int) {
        if item < collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(row: item, section: 0)
            asyncMain {
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideshowCollectionViewCell.className, for: indexPath) as! SlideshowCollectionViewCell
        
        let photo = viewModel?.photoAtIndex(indexPath.row)
        cell.configure(photo: photo, context: mainContext)
        cell.doubleTap = updatePhoto
        cell.longPress = sharePhoto
        cell.accessibilityIdentifier = "Slideshow Cell \(indexPath.row)"
        
        return cell
    }
    
    func sharePhoto(image: UIImage?, title: String?) {
        
        if let image = image, let title = title {
            let vc = UIActivityViewController(activityItems: [title, image], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        let cell = sender.superview?.superview as! SlideshowCollectionViewCell
        cell.updateLikeButtonImage()
        viewModel.savePhoto(cell.photo)
    }
    
    func updatePhoto(_ photo: Photo?) {
        viewModel.savePhoto(photo)
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt : IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: didSelectItemAt) as? SlideshowCollectionViewCell {
            selectedCell.titleLabel.isHidden = !selectedCell.titleLabel.isHidden
        }
    }
    
    // MARK: - SlideshowViewModelDelegate
    
    func presentAlert(_ alertController: UIAlertController) {
        present(alertController, animated: true)
    }
    
    func reloadItems(_ indexPaths: [IndexPath]?, errorPresentation: ErrorPresentation?) {
        if let errorAlert = errorPresentation?.alert  {
            presentAlert(errorAlert)
            return
        }
        
        guard let indexPaths = indexPaths else { return }
        collectionView.reloadItems(at: indexPaths)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(viewModel.itemWidth + viewModel.itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView.contentSize.width)
        var newPage = Float(viewModel.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? viewModel.currentPage + 1 : viewModel.currentPage - 1)
            if newPage < 0 { newPage = 0 }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        viewModel.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}
