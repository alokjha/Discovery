//
//  BannerViewModel.swift
//  Discovery
//
//  Created by Alok Jha on 27/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import RxSwift

class BannerViewModel {
    
    let banners : Observable<[Banner]>
    let client = APIClient()
    
    init() {
        
        let bannerRequest = BannerRequest()
        
        banners = client.send(apiRequest: bannerRequest)
            .map { (response : BannerListResponse)  in
                response.data.banners
            }
            .catchError({ (error) in
                print("Error: \(error)")
                return Observable.just([])
            })
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
    }
}


