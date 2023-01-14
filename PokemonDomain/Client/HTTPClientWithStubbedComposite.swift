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
    private let typeProvider: TypeProviding
    
    public init(prod: HTTPClient, stubbed: HTTPClient, typeProvider: TypeProviding) {
        self.prod = prod
        self.stubbed = stubbed
        self.typeProvider = typeProvider
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        switch typeProvider.current {
        case HTTPClientType.Condition.stubbed:
            stubbed.get(from: url, completion: completion)
        case HTTPClientType.Condition.prod:
            prod.get(from: url, completion: completion)
        default:
            prod.get(from: url, completion: completion)
        }
    }
}
