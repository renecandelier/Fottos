//
//  CategoryCollectionViewCell.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure(with: .none)
        addShadow()
    }
    
    // MARK: - Configuration
    
    func configure(with photo: Photo?) {
        guard let photo = photo else {
            clean()
            return
        }
        if let photoURL = photo.url, let url = URL(string: photoURL), url.isValid {
            asyncMain {
                self.imageView.dowloadFromServer(url: url)
            }
        }
    }
    
    func clean() {
        imageView.image = nil
//        titleLabel.text = ""
    }
    
    override func prepareForReuse() {
        clean()
    }
}
