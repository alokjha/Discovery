//
//  APIClient.swift
//  Discovery
//
//  Created by Alok Jha on 24/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import Foundation
import RxSwift


enum APIClientError: Error {
    case CouldNotDownloadImage
    case Other(Error)
}

extension APIClientError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .CouldNotDownloadImage:
            return "Could not download image"
        case let .Other(error):
            return "\(error)"
        }
    }
}

class APIClient {
        
    private let baseURL = URL(string: "https://staging.omh.sg/itv/_discovery/")!
    
    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    observer.onError(APIClientError.Other(error!))
                    observer.onCompleted()
                    return
                }
                
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(APIClientError.Other(error))
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
                    observer.onError(APIClientError.Other(error!))
                    observer.onCompleted()
                    return
                }
                
                guard let data = data ,let image = UIImage(data:data) else {
                    observer.onError(APIClientError.CouldNotDownloadImage)
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
