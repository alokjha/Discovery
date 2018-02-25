//
//  APIClient.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation
import RxSwift

class APIClient {
        
    private let baseURL = URL(string: "https://staging.omh.sg/itv/_discovery/")!
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    observer.onError(error!)
                    observer.onCompleted()
                    return
                }
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func downloadImage(imageRequest : ImageRequest) -> Observable<UIImage> {
        return Observable<UIImage>.create { [unowned self] observer in
            let request = imageRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    observer.onError(error!)
                    observer.onCompleted()
                    return
                }
                
                guard let data = data ,let image = UIImage(data:data) else {
                    let error = NSError(domain:"ImageRequest", code: 2, userInfo: [NSLocalizedDescriptionKey : "Unable to download image"])
                    observer.onError(error)
                    observer.onCompleted()
                    return
                }
                observer.onNext(image)
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
