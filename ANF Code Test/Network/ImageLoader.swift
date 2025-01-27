//
//  ImageLoader.swift
//  ANF Code Test
//
//  Created by Hana on 1/24/25.
//

import Foundation

import UIKit

class ImageLoader: ImageLoaderProtocol {
    
    // MARK: properties
    private var session: NetworkSessionProtocol
    var imageCache = NSCache<NSString, UIImage>()

    // MARK: init
    init(session: NetworkSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: methods
    func loadImageUsingCacheWithURLString(_ urlString: String,
                                          completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage)
            return
        }
        
        if let url = URL(string: urlString) {
            session.sessionDataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(nil)
                    return
                }
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        self.imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                        completion(downloadedImage)
                    }
                } else {
                    completion(nil)
                }
                
            }).resume()
        }
    }
}

protocol ImageLoaderProtocol {
    func loadImageUsingCacheWithURLString(_ urlString: String, completion: @escaping (UIImage?) -> Void)
}
