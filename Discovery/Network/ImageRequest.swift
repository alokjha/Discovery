//
//  ImageRequest.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation

struct ImageRequest : APIRequest {
    var method = RequestType.GET
    var path = "image"
    var parameters = [String: String]()
    
    init(name: String) {
        parameters["name"] = name
    }
}
