//
//  FottosUITests.swift
//  FottosUITests
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import XCTest

class FottosUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOpenTravel() {
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells["Category Cell 0"].images["Category Image"].tap()
        XCTAssert(app.navigationBars["Travel"].exists)
    }
    
    func testLikePhoto() {
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells["Category Cell 0"].images["Category Image"].tap()
        collectionViewsQuery.cells["Thumbnail Cell 1"].images["Category Image"].tap()
        collectionViewsQuery.cells["Slideshow Cell 1"].buttons["Like"].tap()
        XCUIApplication().tabBars.buttons["Favorites"].tap()
        XCTAssert(!app.staticTexts["No photos saved to your favorites 😞"].exists)
    }
    
    func testOpenFavoritesTab() {
        let app = XCUIApplication()
        app.tabBars.buttons["Favorites"].tap()
        XCTAssert(app.navigationBars["Favorites"].exists)
    }
    
    func testClearFavorites() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Settings"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Remove all saved favorites"]/*[[".cells.staticTexts[\"Remove all saved favorites\"]",".staticTexts[\"Remove all saved favorites\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Favorites"].buttons["OK"].tap()
        tabBarsQuery.buttons["Favorites"].tap()
        XCTAssert(app.staticTexts["No photos saved to your favorites 😞"].exists)
        
    }
    
    func testSavePhotoToFavorites() {
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.cells["Category Cell 0"].images["Category Image"].tap()
        collectionViewsQuery.cells["Thumbnail Cell 0"].images["Category Image"].tap()
        collectionViewsQuery.cells["Slideshow Cell 0"]/*@START_MENU_TOKEN@*/.buttons["Like"]/*[[".buttons[\"LikeOutlined\"]",".buttons[\"Like\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Close"].tap()
        app.tabBars.buttons["Favorites"].tap()
        XCTAssert(!app.staticTexts["No photos saved to your favorites 😞"].exists)

    }
    
}
