//
//  HTTPClient.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Alamofire
import Foundation

/// Network Client (Alamofire) abstraction to structure Network Adapter's methods and handle response cases.
///
public class AFHTTPClient: HTTPClient {

    public init() {}

    public func load<T: Decodable>(_ object: T.Type, from url: String, completion: @escaping (RequestResult<T>) -> Void) {

        AF.request(url)
            .validate()
            .responseDecodable(of: T.self) { response in

                switch response.result {
                case let .success(value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(NetworkError.invalidData))
                }
        }
    }
}
