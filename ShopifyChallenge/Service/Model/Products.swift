//
//  Products.swift
//  ShopifyChallenge
//
//  Created by Ziad Hamdieh on 2019-09-22.
//  Copyright © 2019 Ziad Hamdieh. All rights reserved.
//

struct Products: Decodable {
    let products: [Product]
}

struct Product: Decodable {
    let image: Image
    let variants: [Variant]
    
    enum CodingKeys: String, CodingKey {
        case variants
        case image
    }
}

struct Variant: Decodable {
    let colour: String
    
    enum CodingKeys: String, CodingKey {
        case colour = "title"
    }
}

struct Image: Decodable {
    let urlString: String
    let productID: Int
    
    enum CodingKeys: String, CodingKey {
        case urlString = "src"
        case productID = "product_id"
    }
}
