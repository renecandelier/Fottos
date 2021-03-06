//
//  CategoryCollectionViewCell.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addRoundCorners()
        addShadow()
    }
    
    // MARK: - Configuration
    
    func clean() {
        imageView.image = nil
    }
    
    override func prepareForReuse() {
        clean()
    }
}
