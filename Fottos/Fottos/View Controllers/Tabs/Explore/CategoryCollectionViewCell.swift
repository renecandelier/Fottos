//
//  CategoryCollectionViewCell.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import Nuke

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    
    var category: Category?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addRoundCorners()
        addShadow()
    }
    
    // MARK: - Configuration
    
    func configure(_ category: Category) {
        titleLabel.text? = category.title.localize
        self.category = category
        guard let url = photoUrl else { return }
        Nuke.loadImage(with: url, into: imageView)
    }
    
    var photoUrl: URL? {
        guard let category = category, let url = URL(string: category.image), url.isValid else { return .none }
        return url
    }
    
    func clean() {
        imageView.image = nil
    }
    
    override func prepareForReuse() {
        clean()
    }
}
