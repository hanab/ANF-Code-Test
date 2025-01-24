//
//  MockExploreManager.swift
//  ANF Code TestTests
//
//  Created by Hana on 1/24/25.
//

import Foundation
@testable import ANF_Code_Test

class MockedExploreItemsManager: ExploreManagerProtocol  {
    
    //MARK: Properties
    var fetchCalled = false
    var overrideExploreItems: [ExploreItem]?
    
    //MARK: Methods
    func fetchAllExploreItems(completion: @escaping ([ExploreItem]?) -> Void) {
        if let overrideExploreItems = self.overrideExploreItems {
            completion(overrideExploreItems)
        }
    }
    
    func fetchAllExploreItems(url: URL, completion: @escaping ([ExploreItem]?) -> Void) {
        fetchCalled = true
    }
}
