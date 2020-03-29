//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

/// Network Result
/// Result received from a request.
///
/// When request is successful, delivers Data and HTTPURLResponse.
/// When request is unsuccessful, delivers an Error type.
public typealias HTTPResult = Result<(Data, HTTPURLResponse), Error>

/// Adapter for network requests that enables Network Client abstraction and Spy class implementation for unit testing.
public protocol NetworkAdapter {
    func load(from url: String, completion: @escaping (HTTPResult) -> Void)
}
