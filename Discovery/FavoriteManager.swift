//
//  FavoriteManager.swift
//  Discovery
//
//  Created by Alok Jha on 27/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteManager {
    
    static let shared = FavoriteManager()
    
    let realm = try! Realm()
    
    func addToFavorite(_ card : Card) {
    
        let cards = realm.objects(Card.self).filter("id=%@",card.id)
        
        if cards.count == 0 {
            card.isFavorited = true
            try! realm.write {
                realm.add(card)
            }
        }
        else {
            
            let crd = cards[0]
            try! realm.write {
                crd.isFavorited = true
            }
        }
    
    }
    
    func removeFromFavorite(_ card : Card) {
        
        let cards = realm.objects(Card.self).filter("id=%@",card.id)
        
        if cards.count > 0 {
            let crd = cards[0]
            try! realm.write {
                crd.isFavorited = false
            }
        }
    }
    
    func isFavorite(_ card : Card) -> Bool {
        
        var isFav = false
        let cards = realm.objects(Card.self).filter("id=%@",card.id)
        
        if cards.count > 0 {
            let crd = cards[0]
            isFav = crd.isFavorited
        }
        return isFav
    }
    
}
