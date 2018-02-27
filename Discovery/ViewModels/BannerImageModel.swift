//
//  BannerImageModel.swift
//  Discovery
//
//  Created by Alok Jha on 27/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import RxSwift

class BannerImageModel {
    
    let downloadedImage : Observable<UIImage>
    let client = APIClient()
    
    init(imageName : String) {
        
        let imgRequest = ImageRequest(name: imageName)
        
        downloadedImage = client.downloadImage(imageRequest: imgRequest)
            .observeOn(MainScheduler.instance)
            .catchError({ error in
                print("Error: \(error)")
                return Observable.just(UIImage())
            })
            .share(replay: 1)
    }
}
