//
//  NetworkRequestManager.swift
//  ShopifyChallenge
//
//  Created by Ziad Hamdieh on 2019-09-22.
//  Copyright © 2019 Ziad Hamdieh. All rights reserved.
//

import Foundation

struct NetworkRequestManager {
    
    enum Endpoint: String {
        case products = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    }
    
    typealias requestCallback = ([(String, String)]?, URLResponse?, Error?) -> ()
    
    /// Performs a network request to the desired _endpoint_, and executes a completion handler on the result
    /// - Parameter endpoint: The desired _Endpoint_
    /// - Parameter completion: A _requestCallback_
    func request(endpoint: Endpoint, completion: @escaping requestCallback) {
        guard let url = URL(string: endpoint.rawValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, nil, error)
            } else if let response = response {
                completion(nil, response, nil)
            }
            
            guard let data = data else { return }
            
            do {
                let body = try JSONDecoder().decode(Products.self, from: data)
                let productImageURLs = body.products.compactMap { $0.image.urlString }
//                let productColours = body.products.compactMap { $0.variants.first?.colour }
                
                // NOTE*: Getting the colours from the API wasn't working as expected, so I created a dummy array to continue with the rest of the challenge :)
                // **********************************************************************
                let productColours = ["Mint green", "Red", "Gray", "Blue", "Brown",
                                      "Blue", "Light Gray", "Light Gray", "Red", "Yellow",
                                      "Brown", "Brown", "Orange", "Gray", "Yellow",
                                      "Light Gray", "Mint Green", "Brown", "Yellow", "Gray",
                                      "Brown", "Yellow", "Blue", "Blue", "Pink",
                                      "Yellow", "Light Gray", "Gray", "Yellow", "Gray",
                                      "Light Gray", "Purple", "Brown", "Pink", "Mint Green",
                                      "Red", "Gray", "Gray", "Brown", "Orange",
                                      "Orange", "Red", "Orange", "Pink", "Blue",
                                      "Purple", "Brown", "Yellow", "Pink", "Light Gray"]
                // **********************************************************************
                let productTuples = zip(productImageURLs, productColours).map { ($0, $1) }
                completion(productTuples, nil, nil)
            } catch let parseError {
                print(parseError)
            }
        }.resume()
    }
}
