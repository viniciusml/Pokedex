//
//  HTTPClient.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import Alamofire

public class HTTPClient: NetworkAdapter {
    
    public func load(from url: String, completion: @escaping (HTTPResult) -> Void) {
        
        AF.request(url).responseData { result in
            
            guard let response = result.response else {
                completion(.failure(RemoteLoader.Error.connectivity))
                return
            }
            
            guard let data = result.data else {
                completion(.failure(RemoteLoader.Error.connectivity))
                return
            }
            
            completion(.success((data, response)))
        }
    }
}
