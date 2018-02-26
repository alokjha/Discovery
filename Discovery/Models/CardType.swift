//
//  CardType.swift
//  Discovery
//
//  Created by Alok Jha on 26/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation

enum CardType : String {
    
    case featured
    case latest
    case openHouse
    case under
    case houseRent
    case roomRent
    
    static let staticCardTypes = [CardType.latest , CardType.openHouse , CardType.under]
}

extension CardType {
    
    func headerText() -> String {
        
        switch self {
        case .featured: return "Featured Listings"
        case .latest : return "Latest Listings"
        case .openHouse : return "Open House"
        case .under : return "Listings Under $300,000"
        case .houseRent : return "Latest Flat Rental"
        case .roomRent : return "Latest Rooms For Rent"
        }
    }
    
}
