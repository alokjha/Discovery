//
//  Banner.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation

struct Banner : Codable {
    let id : String
    let imageName : String
    let urlLink : String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case imageName
        case urlLink
    }
}

struct BannerList : Codable {
    let banners : [Banner]
}

 struct BannerListResponse : Codable {
    let data : BannerList
    let message : String
    let statusCode : Int
    
    private enum CodingKeys: String, CodingKey {
        case data = "_data"
        case message = "_message"
        case statusCode = "_statusCode"
    }
}
