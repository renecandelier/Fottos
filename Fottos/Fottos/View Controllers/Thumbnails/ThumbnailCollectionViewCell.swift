//
//  ThumbnailCollectionViewCell.swift
//  Fottos
//
//  Created by Rene Candelier on 1/3/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import UIKit
import Nuke

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addRoundCorners()
    }
    
    func configure(_ url: URL) {
        Nuke.loadImage(with: url, into: imageView)
    }
    
    func clean() {
        imageView.image = nil
    }
    
    override func prepareForReuse() {
        clean()
    }

}
