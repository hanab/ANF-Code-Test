//
//  URLSession+DataTask.swift
//  ANF Code Test
//
//  Created by Hana on 1/24/25.
//

import Foundation

//MARK: Urlsession extension and protocoles used for testing
protocol NetworkSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func sessionDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func sessionDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: NetworkSessionProtocol {
    func sessionDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler)
    }
    
    func sessionDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler)
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
