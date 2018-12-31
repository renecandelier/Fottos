//
//  SlideshowCollectionViewCell.swift
//  Fottos
//
//  Created by Rene Candelier on 12/26/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class SlideshowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var photo: Photo?
    var mainContext: NSManagedObjectContext?

    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateLikeButtonImage))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    // MARK: - Configuration
    
    private func configureAll() {
        addShadow()
    }
    
    override func prepareForReuse() {
        photo = nil
        titleLabel.isHidden = true
//        likeButton.setImage(UIImage(named: "LikeOutlined"), for: .normal)
        if imageView != nil {
            imageView.image = nil
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        updateLikeButtonImage()
    }
    
    @objc
    func updateLikeButtonImage() {
        likeButton.setImage(rotateLikeImage(likeButton.currentImage), for: .normal)
    }
    
    func rotateLikeImage(_ likeImage: UIImage?) -> UIImage {
        
        if likeImage == UIImage(named: "LikeOutlined") {
                if let context = Store.shareInstance?.persistentContainer.viewContext, let photo = photo {
                    createPhoto(context: context, photo: photo)
                }
            return UIImage(named: "Like")!
        } else {
            return UIImage(named: "LikeOutlined")!
        }
        
    }
    
    func createPhoto(context: NSManagedObjectContext?, photo: Photo) {
        guard let context = context else { return }
        Favorite.addNew(context: context, photo: photo)
        Store.shareInstance?.saveContext()
    }
}
