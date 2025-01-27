//
//  ExploreManagerTest.swift
//  ANF Code TestTests
//
//  Created by Hana on 1/27/25.
//

import Foundation

@testable import ANF_Code_Test
import XCTest

class ExploreManagerTest: XCTestCase {
    
    //MARK: Properties
    var exploreManager: ExploreManager!
    var session = MockURLSession()
    
    let mockStringData = """
            [
                  {
                    "title": "TOPS STARTING AT $12",
                    "backgroundImage": "anf-20160527-app-m-shirts",
                    "content": [
                      {
                        "target": "https://www.abercrombie.com/shop/us/mens-new-arrivals",
                        "title": "Shop Men"
                      },
                      {
                        "target": "https://www.abercrombie.com/shop/us/womens-new-arrivals",
                        "title": "Shop Women"
                      }
                    ],
                    "promoMessage": "USE CODE: 12345",
                    "topDescription": "A&F ESSENTIALS",
                    "bottomDescription": "*In stores & online. <a href=\\\"http://www.abercrombie.com/anf/media/legalText/viewDetailsText20160602_Tier_Promo_US.html\\\">Exclusions apply. See Details</a>"
                  },
                  {
                    "title": "T-SHIRT DRESSES",
                    "backgroundImage": "anf-US-20160601-app-women-dresses.jpg",
                    "topDescription": "THROW ON & GO",
                    "content": [
                      {
                        "elementType": "hyperlink",
                        "target": "https://www.abercrombie.com/shop/us/womens-dresses-and-rompers",
                        "title": "SHOP NOW"
                      }
                    ]
                  }
            ]
            """
    
    override func setUp() {
        super.setUp()
        exploreManager = ExploreManager(session: session)
    }
    
    //MARK: TestCases
    func testDataTaskResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        exploreManager.fetchAllExploreItems { _ in }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testDataTaskSetSessionUrl() {
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        guard let url = URL(string: "https://myurl") else {
            fatalError("URL can't be empty")
        }
        
        exploreManager.fetchAllExploreItems(url: url) { _ in }
        XCTAssert((session.mockURL == url))
    }
    
    func testFetchAllExploreItemsWithValidData() {
        let mockData = mockStringData.data(using: .utf8)
        session.mockData = mockData
        let expectation = self.expectation(description: "Completion handler called")
        
        guard let url = URL(string: "http://example.com") else {
            fatalError("URL can't be empty")
        }
        exploreManager.fetchAllExploreItems(url: url) { exploreItems in
            XCTAssertNotNil(exploreItems, "Explore items should not be nil")
            XCTAssertEqual(exploreItems?.count, 2, "There should be 2 explore items")
            XCTAssertEqual(exploreItems?.first?.title, "TOPS STARTING AT $12", "First item should be 'TOPS STARTING AT $12'")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchAllExploreItemsWithDefaultURL() {
        let mockData = mockStringData.data(using: .utf8)
        session.mockData = mockData
        let expectation = self.expectation(description: "Completion handler called")
        
        exploreManager.fetchAllExploreItems { exploreItems in
            XCTAssertNotNil(exploreItems, "Explore items should not be nil")
            XCTAssertEqual(exploreItems?.count, 2, "There should be 2 explore items")
            XCTAssertEqual(exploreItems?.last?.title, "T-SHIRT DRESSES", "Last item should be 'T-SHIRT DRESSES'")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchAllExploreItemsWithError() {
        session.mockError = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        let expectation = self.expectation(description: "Completion handler called with nil data")
        
        guard let url = URL(string: "http://example.com") else {
            fatalError("URL can't be empty")
        }
        exploreManager.fetchAllExploreItems(url: url) { exploreItems in
            XCTAssertNil(exploreItems, "Explore items should be nil when there's an error")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchAllExploreItemsWithInvalidData() {
        let invalidData = "Invalid JSON data".data(using: .utf8)
        session.mockData = invalidData
        let expectation = self.expectation(description: "Completion handler called with nil data")
        
        guard let url = URL(string: "http://example.com") else {
            fatalError("URL can't be empty")
        }
        exploreManager.fetchAllExploreItems(url: url) { exploreItems in
            XCTAssertNil(exploreItems, "Explore items should be nil when the data is invalid")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
