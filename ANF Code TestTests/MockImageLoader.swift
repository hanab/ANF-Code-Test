//
//  MockImageLoader.swift
//  ANF Code TestTests
//
//  Created by Hana on 1/27/25.
//

import Foundation

import UIKit
@testable import ANF_Code_Test

class MockImageLoader: ImageLoaderProtocol {
    var loadedImage: UIImage?
    
    func loadImageUsingCacheWithURLString(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mockImage = UIImage(named: "anf-US-20160415-app-men-essentials")
            self.loadedImage = mockImage
            completion(mockImage)
        }
    }
}
