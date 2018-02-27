//
//  CardViewModel.swift
//  Discovery
//
//  Created by Alok Jha on 27/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import RxSwift

class CardViewModel {
    
    let client = APIClient()
    let cardType : CardType
    let cards : Observable<[Card]>
    
    init(cardType : CardType) {
        
        self.cardType = cardType
        
        let cardRequest = CardRequest(name: cardType.rawValue)
        
        cards = client.send(apiRequest: cardRequest)
            .map { (response : CardListResponse)  in
                response.data.cards
            }
            .catchError({ (error) in
                print("Error: \(error)")
                return Observable.just([])
            })
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
    }
}
