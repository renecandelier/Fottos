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

    var photo: Photo? {
        didSet {
            loadHeartImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }
    
    // MARK: - Configuration
    
    private func addDoubleTap() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateLikeButtonImage))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    private func configureAll() {
        addShadow()
    }
    
    override func prepareForReuse() {
        photo = nil
        titleLabel.isHidden = true
        likeButton.setImage(outlinedHeart, for: .normal)
        if imageView != nil {
            imageView.image = nil
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        //        updateLikeButtonImage()
    }
    
    func rotateLikeImage(_ likeImage: UIImage?) -> UIImage {
        
        return likeImage == outlinedHeart ? filledHeart : outlinedHeart
    }
    
    func loadHeartImage() {
        guard let context = context, let photo = photo else { return }
        let heartImage = Favorite.isPhotoSaved(context: context, photo: photo) ? filledHeart : outlinedHeart
        likeButton.setImage(heartImage, for: .normal)
    }
    
    @objc
    func updateLikeButtonImage() {
        likeButton.setImage(rotateLikeImage(likeButton.currentImage), for: .normal)
    }
}
