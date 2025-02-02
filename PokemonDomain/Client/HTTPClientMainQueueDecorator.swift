//
//  HTTPClientDecorator.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 10/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class HTTPClientMainQueueDecorator: HTTPClient {
    private let decoratee: HTTPClient
    
    public init(_ decoratee: HTTPClient) {
        self.decoratee = decoratee
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        decoratee.get(from: url) { result in
            guaranteeMainThread {
                completion(result)
            }
        }
    }
}

fileprivate func guaranteeMainThread(_ work: @escaping () -> Void) {
    Thread.isMainThread ? work() : DispatchQueue.main.async(execute: work)
}
