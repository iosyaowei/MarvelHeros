//
//  MarvelHeroesTests.swift
//  MarvelHeroesTests
//
//  Created by 姚巍 on 2018/3/18.
//  Copyright © 2018年 姚巍. All rights reserved.
//

import XCTest

class MarvelHeroesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension MarvelHeroesTests {
    func testGETRequest() {
        let expectation = self.expectation(description: "GET Test")
        
        let URLStr = MN_SERVER_URL + "public/characters"
        let params = ["limit" : 20, "offset": 0]
        MHNetworkManager.shared.get(URLStr: URLStr, params: params) { (data, code, isSuccess) in
            expectation.fulfill()
            
            XCTAssertTrue(isSuccess, "request error")
            XCTAssertEqual(code, 200, "HTTP response status code should be 200")
            XCTAssertNotNil(data, "返回数据不应非 nil")
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            XCTAssertNil(error, (error?.localizedDescription)!)
        }
    }
    
    func testDownloadRequest() {
        let expectation = self.expectation(description: "Download Test")
        
        let URLStr = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"
        MHNetworkManager.shared.downloadImage(URLStr: URLStr) { (data, isSuccess) in
            expectation.fulfill()
            
            XCTAssertNotNil(data, "返回数据不应非 nil")
            XCTAssertTrue(isSuccess, "request error")
        }
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, (error?.localizedDescription)!)
        }
    }
    
}

