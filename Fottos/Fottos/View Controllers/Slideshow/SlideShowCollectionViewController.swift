//
//  ExploreViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/20/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
private let reuseIdentifier = "CategoryCollectionViewCell"

class SlideshowCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let collectionMargin = CGFloat(16)
    let itemSpacing = CGFloat(10)
    let itemHeight = CGFloat(322)
    var itemWidth = CGFloat(0)
    
    var photos = [Photo]()
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToItem(currentPage)
    }
    
    func setCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)

        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.decelerationRate = .fast
    }
    
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
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        if let url = photos[indexPath.row].imageURL {
            cell.imageView.dowloadFromServer(url: url)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width  )
        var newPage = Float(currentPage)

        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? currentPage + 1 : currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }

        currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
}
