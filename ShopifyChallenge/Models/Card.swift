//
//  Card.swift
//  ShopifyChallenge
//
//  Created by Ziad Hamdieh on 2019-09-22.
//  Copyright © 2019 Ziad Hamdieh. All rights reserved.
//

import Foundation

class Card {
    
    var colour: String
    var imageURLString: String
    var isUncovered: Bool
    var hasBeenMatched: Bool
    
    init() {
        self.isUncovered = false
        self.hasBeenMatched = false
        self.imageURLString = ""
        self.colour = ""
    }
    
    convenience init(from productTuple: (String, String)) {
        self.init()
        
        self.imageURLString = productTuple.0
        self.colour = productTuple.1
    }
}
