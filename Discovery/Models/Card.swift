//
//  Card.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation
import RealmSwift

class Address : Object , Codable {
    @objc dynamic var  block : String = ""
    @objc dynamic var road : String = ""
}

class Card :Object ,Codable {
    
    @objc dynamic var id : String = ""
    @objc dynamic var imageName : String = ""
    @objc dynamic var price : String = ""
    @objc dynamic var numBeds : Int = 0
    @objc dynamic var numToilets : Int = 0
    @objc dynamic var sizeSQM : String = ""
    @objc dynamic var address : Address?
    @objc dynamic var isFavorited : Bool = false
    
    var addressString : String {
        return address!.block +  " " + address!.road
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
