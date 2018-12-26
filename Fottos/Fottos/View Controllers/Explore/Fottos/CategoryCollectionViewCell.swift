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
        configureAll()
    }
    
    // MARK: - Configuration
    
    private func configureAll() {
        configureCell()
    }
    
    override func prepareForReuse() {
        if imageView != nil {
            imageView.image = nil
        }
    }
    
    private func configureCell() {
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = self.contentView.layer.cornerRadius
    }
}
