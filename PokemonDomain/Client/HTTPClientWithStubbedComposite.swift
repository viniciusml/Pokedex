//
//  HTTPClientWithStubbedComposite.swift
//  PokemonDomain
//
//  Created by Vinicius Leal on 14/01/2023.
//  Copyright © 2023 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public class HTTPClientWithStubbedComposite: HTTPClient {
    private let prod: HTTPClient
    private let stubbed: HTTPClient
    private let clientType: HTTPClientType.ClientType
    
    public init(prod: HTTPClient, stubbed: HTTPClient, clientType: HTTPClientType.ClientType) {
        self.prod = prod
        self.stubbed = stubbed
        self.clientType = clientType
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        switch clientType {
        case .prod:
            prod.get(from: url, completion: completion)
        case .stubbed:
            stubbed.get(from: url, completion: completion)
        }
    }
}
