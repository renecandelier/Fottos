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
    
    let collectionMargin = CGFloat(16)
    let itemSpacing = CGFloat(10)
    var itemHeight = CGFloat(322)
    var itemWidth = CGFloat(0)
    
    // MARK: - Properties
    
    var mainContext: NSManagedObjectContext?
    var viewModel: SlideshowViewModel!
    var currentPage = 0
    var photos: [Photo]?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainContext = Store.shareInstance?.persistentContainer.viewContext
        viewModel = SlideshowViewModel(photos: photos, currentPage: currentPage, delegate: self, context: mainContext)
        setCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToItem(viewModel?.currentPage ?? 0)
    }
    
    // TODO: Clean
    func setCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        itemHeight = (collectionView.bounds.height - collectionMargin - itemWidth)
        layout.sectionInset = UIEdgeInsets(top: itemHeight/2, left: 0, bottom: itemHeight/2, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)

        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.decelerationRate = .fast
    }
    
    // TODO: Clean
    func scrollToItem(_ item: Int) {
        if item < self.collectionView.numberOfItems(inSection: 0) {
            asyncMain({  [weak self] in
                guard let self = self else { return }
                self.collectionView.scrollToItem(at: IndexPath(row: item, section: 0), at: .centeredHorizontally, animated: false)
            })
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
        
        cell.context = mainContext
        let photo = viewModel?.photoAtIndex(indexPath.row)
        cell.photo = photo
        cell.doubleTap = updatePhoto
        cell.longPress = sharePhoto
        if let photoURL = photo?.url, let url = URL(string: photoURL), url.isValid {
            cell.titleLabel.text = photo?.title ?? ""
            // TODO: Move this to VM
            cell.imageView.dowloadFromServer(url: url) { (image, _) in
                guard let image = image else { return }
                cell.imageView.image = image
            }
        }
        
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
    // TODO: Clean
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView.contentSize.width  )
        var newPage = Float(viewModel.currentPage)

        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? viewModel.currentPage + 1 : viewModel.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }

        viewModel.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}
