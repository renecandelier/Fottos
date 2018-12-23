//
//  SearchViewController.swift
//  Fottos
//
//  Created by Rene Candelier on 12/21/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    func shouldResignKeyBoard(_ textField:UITextField) -> Bool {
        if let text = textField.text, text.isEmpty {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if shouldResignKeyBoard(textField) {
            textField.resignFirstResponder()
        }
//        searchNewPhotos(textField.text)
        return true
    }

}


