//
//  MarvelHeroesUITests.swift
//  MarvelHeroesUITests
//
//  Created by 姚巍 on 2018/3/18.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import XCTest

class MarvelHeroesUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}

extension MarvelHeroesUITests {
    func testLikeHero() {
        
        let app = XCUIApplication()
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"A.I.M.").element.tap()
        
        let heroId = 1009144
        let beforeLikeStatus = !MHCoreDataManager.shared.selectLikeHeroData(heroId: heroId).isEmpty
        
        let detailLikeButton = app.tables.buttons["detail like"]
        detailLikeButton.tap()
        
        let currentLikeStatus = !MHCoreDataManager.shared.selectLikeHeroData(heroId: heroId).isEmpty
        XCTAssertEqual(beforeLikeStatus, !currentLikeStatus, "Like status no change")
        
    }
}
