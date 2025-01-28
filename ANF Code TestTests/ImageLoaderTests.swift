//
//  ImageLoaderTests.swift
//  ANF Code TestTests
//
//  Created by Hana on 1/27/25.
//

import XCTest
@testable import ANF_Code_Test

class ImageLoaderTests: XCTestCase {
    
    // MARK: properties
    var imageLoader: ImageLoader!
    var mockSession: MockURLSession!
    
    // MARK: lifecycle
    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession()
        imageLoader = ImageLoader(session: mockSession)
    }
    
    override func tearDown() {
        imageLoader = nil
        mockSession = nil
        super.tearDown()
    }
    
    // MARK: testcases
    func testLoadImageFromCache() {
        let urlString = "https://example.com/image.jpg"
        guard let image = UIImage(named: "anf-20160527-app-m-shirts") else {
            XCTFail("Can not find image named: 'anf-20160527-app-m-shirts'")
            return
        }
        imageLoader.imageCache.setObject(image, forKey: urlString as NSString)
        
        let expectation = self.expectation(description: "Image loaded from cache")
        imageLoader.loadImageUsingCacheWithURLString(urlString) { loadedImage in
            XCTAssertEqual(loadedImage, image, "The image returned should be the same as the cached image.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadImageFromNetwork() {
        let urlString = "https://example.com/image.jpg"
        guard let image = UIImage(named: "anf-US-20160415-app-men-essentials") else {
            XCTFail("Can not find image named: 'anf-US-20160415-app-men-essentials'")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            XCTFail("Failed to convert image to JPG data.")
            return
        }
        mockSession.mockData = imageData
        
        let expectation = self.expectation(description: "Image loaded from network")
        imageLoader.loadImageUsingCacheWithURLString(urlString) { loadedImage in
            XCTAssertNotNil(loadedImage, "Image should not be nil")
            guard let loadedImage = loadedImage else {
                XCTFail("Failed to convert image to JPG data.")
                return
            }
            // Ideally we would to compare the images are equal, however their bytes differ
            // so checking other properites of the image
            XCTAssertEqual(loadedImage.size, image.size,  "The images size should be equal")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadImageWithFailure() {
        let urlString = "https://example.com/image.jpg"
        mockSession.mockError = NSError(domain: "NetworkError", code: 500, userInfo: nil)
        
        let expectation = self.expectation(description: "Image loading should fail")
        imageLoader.loadImageUsingCacheWithURLString(urlString) { loadedImage in
            XCTAssertNil(loadedImage, "The image should be nil due to network failure.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadImageWithInvalidURL() {
        let urlString = "invalid-url"
        let expectation = self.expectation(description: "Image loading should fail for invalid URL")
        
        imageLoader.loadImageUsingCacheWithURLString(urlString) { loadedImage in
            XCTAssertNil(loadedImage, "The image should be nil due to invalid URL.")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
