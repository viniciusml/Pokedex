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
public final class AFHTTPClient: HTTPClient {
    private let session: Session
    private let queue = DispatchQueue(label: "com.pokedex", qos: .utility, attributes: .concurrent)
    
    public init(sessionConfiguration: URLSessionConfiguration = .default) {
        self.session = Session(configuration: sessionConfiguration)
    }
    
    private enum Error: Swift.Error {
        case unexpectedValuesRepresentation
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        session.request(url).response(queue: queue) { response in
            if let error = response.error {
                completion(.failure(error))
            } else if let data = response.data, let response = response.response {
                completion(.success((data, response)))
            } else {
                completion(.failure(Error.unexpectedValuesRepresentation))
            }
        }
    }
}
