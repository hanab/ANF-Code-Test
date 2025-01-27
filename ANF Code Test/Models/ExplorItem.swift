//
//  ExploreItem.swift
//  ANF Code Test
//
//  Created by Hana on 1/23/25.
//

struct ExploreItem: Codable {
    let title: String, backgroundImage: String
    let content: [Content]?
    let promoMessage, topDescription, bottomDescription: String?
}

struct Content: Codable {
    let title, target: String
    let elementType: String?
}
