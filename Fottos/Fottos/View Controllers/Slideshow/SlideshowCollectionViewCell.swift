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
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    let filledHeart = UIImage(imageLiteralResourceName: "Like")
    let outlinedHeart = UIImage(imageLiteralResourceName: "LikeOutlined")
    var context: NSManagedObjectContext?
    var doubleTap: ((_ : Photo?) -> Void)?
    
    var photo: Photo? {
        didSet {
            loadHeartImage()
        }
    }
    
    // MARK: - Configuration
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        addDoubleTap()
    }
    
    private func addDoubleTap() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateSavedPhoto))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    override func prepareForReuse() {
        photo = nil
        titleLabel.isHidden = true
        likeButton.setImage(outlinedHeart, for: .normal)
        if imageView != nil {
            imageView.image = nil
        }
    }
    
    func rotateLikeImage(_ likeImage: UIImage?) -> UIImage {
        return likeImage == outlinedHeart ? filledHeart : outlinedHeart
    }
    
    func loadHeartImage() {
        guard let context = context, let photo = photo else { return }
        let heartImage = Favorite.isPhotoSaved(context: context, photo: photo) ? filledHeart : outlinedHeart
        setHeartImage(heartImage)
    }
    
    @objc
    func updateSavedPhoto() {
        doubleTap?(photo)
        updateLikeButtonImage()
    }
    
    func updateLikeButtonImage() {
        setHeartImage(rotateLikeImage(likeButton.currentImage))
    }
    
    func setHeartImage(_ image: UIImage) {
        likeButton.setImage(image, for: .normal)
    }
}
