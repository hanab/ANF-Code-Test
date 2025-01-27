//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//


import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {
    
    // MARK: Properties
    var testInstance: ANFExploreCardTableViewController!
    var mockExploreManager: MockedExploreItemsManager!
    var mockImageLoader: MockImageLoader!
    
    private var exploreData: [ExploreItem]? {
        if let filePath = Bundle.main.path(forResource: "exploreData", ofType: "json"),
           let fileContent = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let jsonDictionary = try? JSONDecoder().decode([ExploreItem].self, from: fileContent) {
            return jsonDictionary
        }
        return nil
    }
    
    // MARK: setup
    override func setUp() {
        mockExploreManager = MockedExploreItemsManager()
        mockExploreManager.overrideExploreItems = exploreData
        mockImageLoader = MockImageLoader()
        testInstance = ANFExploreCardTableViewController.vc(exploreManager: mockExploreManager, imageLoader: mockImageLoader)
        testInstance.loadViewIfNeeded()
    }
    
    func test_numberOfSections_ShouldBeOne() {
        let numberOfSections = testInstance.numberOfSections(in: testInstance.tableView)
        XCTAssert(numberOfSections == 1, "table view should have 1 section")
    }
    
    func test_numberOfRows_ShouldBeTen() {
        let numberOfRows = testInstance.tableView(testInstance.tableView, numberOfRowsInSection: 0)
        XCTAssert(numberOfRows == 10, "table view should have 10 cells")
    }
    
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreItemTableViewCell
        let title = firstCell?.titleLabel
        XCTAssert(title?.text?.count ?? 0 > 0, "title should not be blank")
        XCTAssert(title?.font == UIFont.systemFont(ofSize: 17).bold(), "font should be size 17 bold")
    }
    
    func test_cellForRowAtIndexPath_ImageViewImage_shouldNotBeNil() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreItemTableViewCell
        let imageView = firstCell?.backgroundImageView
        XCTAssert(imageView?.image != nil, "image view image should not be nil")
    }
    
    func test_cellForRowAtIndexPath_topDescriptionText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreItemTableViewCell
        let topDescriptionLabel = firstCell?.topDescriptionLabel
        XCTAssert(topDescriptionLabel?.text?.count ?? 0 > 0, "top description should not be blank")
        XCTAssert(topDescriptionLabel?.font == UIFont.systemFont(ofSize: 13), "font should be size 13")
    }
    
    func test_cellForRowAtIndexPath_promoMessageText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreItemTableViewCell
        let promoMessage = firstCell?.promoMessage
        XCTAssert(promoMessage?.text?.count ?? 0 > 0, "promo message should not be blank")
        XCTAssert(promoMessage?.font == UIFont.systemFont(ofSize: 11), "font should be size 11")
    }
    
    func test_cellForRowAtIndexPath_bottomDescriptionText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreItemTableViewCell
        let bottomDescription = firstCell?.bottomDescription
        XCTAssert(bottomDescription?.text?.count ?? 0 > 0, "bottom description should not be blank")
        XCTAssert(bottomDescription?.font == UIFont.systemFont(ofSize: 13), "font should be size 13")
    }
    
    func test_cellForRowAtIndexPath_exploreContentView_shouldHaveButtons() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreItemTableViewCell
        let exploreContentView = firstCell?.exploreContentView
        XCTAssert(exploreContentView?.stackView.arrangedSubviews.count == 2, "content view should have two buttons")
        
        for view in exploreContentView?.stackView.arrangedSubviews ?? [] {
            let buttonView = view as? ContentButtonsView
            XCTAssert(buttonView?.contentButton.titleLabel?.text != nil, "button title should not be balnk")
            XCTAssert(buttonView?.contentButton.titleLabel?.font == UIFont.systemFont(ofSize: 15), "font should be size 15")
        }
    }
    
    func testFetchAllExploreItemsCalled() {
        let expectation = self.expectation(description: "Fetch explore items")
        testInstance.viewDidLoad()
        
        DispatchQueue.main.async {
            XCTAssertTrue(self.mockExploreManager.fetchCalled, "fetchAllExploreItems should be called")
            XCTAssertEqual(self.mockExploreManager.overrideExploreItems?.count, 10, "fetchAllExploreItems should set the overrideExploreItems")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testImageLoading() {
        let expectation = self.expectation(description: "Image loading completes")
        testInstance.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNotNil(self.testInstance.images.first ?? nil, "The first image should not be nil")
            XCTAssertEqual(self.testInstance.images.count, 10, "There should be 2 images loaded")
            XCTAssertEqual(self.mockImageLoader.loadedImage, UIImage(named: "anf-US-20160415-app-men-essentials"), "The image loaded should be the mock image")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchAllExploreItemsWhenAppIsActive() {
        let expectation = self.expectation(description: "Fetch data when app becomes active")
        
        // Simulate the app becoming active
        NotificationCenter.default.post(name: UIApplication.didBecomeActiveNotification, object: nil)
        
        DispatchQueue.main.async {
            XCTAssertTrue(self.mockExploreManager.fetchCalled, "fetchAllExploreItemsWhenAppIsActive should trigger fetchAllExploreItems")
            XCTAssertEqual(self.mockExploreManager.overrideExploreItems?.count, 10, "fetchAllExploreItems should set the overrideExploreItems")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
