//
//  PhotoMetadataTests.swift
//  FottosTests
//
//  Created by Rene Candelier on 1/6/19.
//  Copyright © 2019 Novus Mobile. All rights reserved.
//

import XCTest
@testable import Fottos

class PhotoMetaDataTest: XCTestCase {
    
    let photoDictionary: PhotoDictionary = [Keys.photoId : "31620239757",
                                            Keys.secret: "eb1068c859",
                                            Keys.server: "4875",
                                            Keys.farm: 5,
                                            Keys.title: "Figura Funko POP Ni No Kuni Roland with Higgledy"]
    
    func testValidPhotoMetaDataURL() {
        let photoMetaData = PhotoMetadata(photoDictionary)
        let imageURL = photoMetaData.imageURL
        let finalURL = URL(string: "https://farm5.staticflickr.com/4875/31620239757_eb1068c859.jpg")
        XCTAssertTrue(imageURL == finalURL, "URL is not correct")
    }
    
    func testInvalidPhotoMetaDataURL() {
        let photoMetaData = PhotoMetadata(photoDictionary)
        let imageURL = photoMetaData.imageURL
        let finalURL = URL(string: "https://farm444444444.staticflickr.com/4875/31620239757_eb1068c859.jpg")
        XCTAssertFalse(imageURL == finalURL, "URL is correct")
    }
    
    func testInvalidFarmString() {
        let photoDictionary: PhotoDictionary = [Keys.photoId : "31620239757",
                                                Keys.secret: "eb1068c859",
                                                Keys.server: "4875",
                                                Keys.farm: "5",
                                                Keys.title: "Figura Funko POP Ni No Kuni Roland with Higgledy"]
        let photoMetaData = PhotoMetadata(photoDictionary)
        let imageURL = photoMetaData.url
        
        let finalURL = "https://farm5.staticflickr.com/4875/31620239757_eb1068c859.jpg"
        XCTAssertFalse(imageURL == finalURL, "URL is correct")
    }
    
    func testValidFarmInt() {
        let photoDictionary: PhotoDictionary = [Keys.photoId : "31620239757",
                                                Keys.secret: "eb1068c859",
                                                Keys.server: "4875",
                                                Keys.farm: 0,
                                                Keys.title: "Figura Funko POP Ni No Kuni Roland with Higgledy"]
        let photoMetaData = PhotoMetadata(photoDictionary)
        let imageURL = photoMetaData.url
        
        let finalURL = "https://farm0.staticflickr.com/4875/31620239757_eb1068c859.jpg"
        XCTAssertTrue(imageURL == finalURL, "URL is incorrect")
    }
}
