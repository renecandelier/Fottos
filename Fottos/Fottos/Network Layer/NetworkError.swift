//
//  NetworkError.swift
//  Fottos
//
//  Created by Rene Candelier on 1/1/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case invalidURL = "URL is invalid."
    case noData = "No data availale."
    case decoding = "Error occured while decoding."
    case network = "An error occured when fetching data."
}
