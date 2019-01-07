//
//  TypeAliases.swift
//  Fottos
//
//  Created by Rene Candelier on 1/4/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import Foundation
import UIKit

public typealias NetworkCompletionHandler = ((JsonDictionary?, Data?, URLResponse?, Error?) -> Void)
public typealias NetworkResponseCompletionHandler = ((Data?, URLResponse?, Error?) -> Void)
public typealias JsonDictionary = [String: Any]
public typealias Parameters = [String: Any]
public typealias Components = (key: String, value: String)
typealias SearchTerms = [String]
typealias ErrorAlert = UIAlertController
typealias PhotoDictionary = [String: Any]
typealias ConfigDictionary = [String: Any]
typealias EndpointDictionary = [String: Any]
typealias CategoryDictionary = [String: String]
typealias PhotoDownloadDictionary = [String: String]
typealias SearchPhotosDictionary = [String: Any]
typealias QueryItems = [String: String]
typealias ReplacementTokens = [String: String]
