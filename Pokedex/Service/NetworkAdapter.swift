//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public typealias RequestResult = Result<HTTPURLResponse, Error>

public protocol NetworkAdapter {
    func load(from url: URL, completion: @escaping (RequestResult) -> Void)
}
