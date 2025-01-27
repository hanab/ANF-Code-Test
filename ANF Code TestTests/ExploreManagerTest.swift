//
//  ExploreItemsNetworkTest.swift
//  ANF Code TestTests
//
//  Created by Hana on 1/27/25.
//

import Foundation

@testable import ANF_Code_Test
import XCTest

class ExploreItemsNetworkTest: XCTestCase {
    
    //MARK: Properties
    var exploreItemsManager: ExploreManager!
    var session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        exploreItemsManager = ExploreManager(session: session)
    }
    
    //MARK: TestCases
    func testDataTaskResumeCalled() {
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        exploreItemsManager.fetchAllExploreItems { _ in }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testDataTaskSetSessionUrl() {
        let dataTask = MockURLSessionDataTask()
        session.mockDataTask = dataTask
        
        guard let url = URL(string: "https://myurl") else {
            fatalError("URL can't be empty")
        }
        
        exploreItemsManager.fetchAllExploreItems(url: url) { _ in }
        XCTAssert((session.mockURL == url))
    }
    
}
