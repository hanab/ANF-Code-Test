//
//  Extensions+UIImageView.swift
//  ANF Code Test
//
//  Created by Hana on 1/24/25.
//

import Foundation

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageLoader: ImageLoaderProtocol {
    
    //MARK: extention to load and catch image asynchronously
    func loadImageUsingCacheWithURLString(_ urlString: String,
                                          completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage)
            return
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(nil)
                    return
                }
                if let data = data {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
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
