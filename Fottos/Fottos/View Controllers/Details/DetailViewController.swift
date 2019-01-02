//
//  SlideshowCollectionViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/20/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var photos: [Photo]?
    var currentPage = 0
    
    @IBAction func swipeDismissView(_ sender: UIPanGestureRecognizer) {
        dismissView()
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        dismissView()
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SlideshowCollectionViewController.className {
            guard let slideshowCollectionViewController = segue.destination as? SlideshowCollectionViewController else { return }
            slideshowCollectionViewController.currentPage = currentPage
            slideshowCollectionViewController.photos = photos
        }
    }
}
