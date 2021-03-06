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
    func testLikeOrDislikeHero() {
        let app = XCUIApplication()
        let window = app.windows.element(boundBy: 0)
        
        let delayTime: TimeInterval = 3
        window.press(forDuration: delayTime)
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        window.press(forDuration: delayTime)
        
        let detailLikeButton = app.tables.buttons["LikeHeroIdentifier"]
        let beforeIsLike = detailLikeButton.isSelected
        window.press(forDuration: delayTime)
        
        detailLikeButton.tap()
        window.press(forDuration: delayTime)
        
        let nowIsLike  = detailLikeButton.isSelected
        XCTAssertEqual(beforeIsLike, !nowIsLike, "Like status no change")
    }
}

