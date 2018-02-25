//
//  Card.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation

struct Address : Codable {
    let block : String
    let road : String
}

struct Card : Codable {
    let id : String
    let imageName : String
    let price : String
    let numBeds : Int
    let numToilets : Int
    let sizeSQM : String
    let address : Address
    
    var addressString : String {
        return address.block +  " " + address.road
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageName
        case price
        case numBeds = "numberOfBeds"
        case numToilets = "numberOfToilets"
        case sizeSQM
        case address
    }
    
}

struct CardList : Codable {
    let cards : [Card]
}

struct CardListResponse : Codable {
    let data : CardList
    let message : String
    let statusCode : Int
    
    private enum CodingKeys: String, CodingKey {
        case data = "_data"
        case message = "_message"
        case statusCode = "_statusCode"
    }
}
