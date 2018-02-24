//
//  BannerRequest.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation

struct BannerRequest : APIRequest {
    var method = RequestType.GET
    var path = "banners"
    var parameters = [String: String]()
}
