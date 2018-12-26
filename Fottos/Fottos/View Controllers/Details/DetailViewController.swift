//
//  ExploreViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/20/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
private let reuseIdentifier = "CategoryCollectionViewCell"

class DetailViewController: UIViewController {
    
    var photos = [Photo]()
    
    var currentPage = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SlideshowCollectionViewController" {
            if let slideshowCollectionViewController = segue.destination as? SlideshowCollectionViewController {
                slideshowCollectionViewController.currentPage = currentPage
                slideshowCollectionViewController.photos = photos
            }
        }
    }
    
    @IBAction func swipeDismissView(_ sender: UIPanGestureRecognizer) {
        dismissView()
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        dismissView()
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
