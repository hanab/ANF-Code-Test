//
//  ExploreManager.swift
//  ANF Code Test
//
//  Created by Hana on 1/24/25.
//

import Foundation


import Foundation

protocol ExploreManagerProtocol {
    func fetchAllExploreItems(completion: @escaping ([ExploreItem]?) -> Void)
    func fetchAllExploreItems(url: URL, completion: @escaping ([ExploreItem]?) -> Void)
}

class ExploreManager: ExploreManagerProtocol {
    
    //MARK: Properties
    private let session: NetworkSessionProtocol
    
    //MARK: Init
    init(session: NetworkSessionProtocol) {
        self.session = session
    }
    
    //MARK: Methods
    func fetchAllExploreItems(url: URL, completion: @escaping ([ExploreItem]?) -> Void) {
        let request = URLRequest(url: url)
        let task = session.sessionDataTask(with: request,
                                           completionHandler:  { (data, response, error) -> Void in
            if let error = error {
                completion(nil)
                print("error: ", error)
                return
            }
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([ExploreItem].self, from: data)
                    completion(decodedResponse)
                } catch {
                    completion(nil)
                    print("error: ", error)
               }
            }
        })
        task.resume()
    }
    
    func fetchAllExploreItems( completion: @escaping ([ExploreItem]?) -> Void) {
        let urlString = "https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.css"
        guard let url = URL(string: urlString) else {
            return
        }
        fetchAllExploreItems(url: url, completion: completion)
    }
}
