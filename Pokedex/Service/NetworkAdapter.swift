//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias RequestResult = Result<[ResultItem], Error>

protocol NetworkAdapter {
    func load(completion: @escaping (RequestResult) -> Void)
}
