//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 25/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias ListResult = Result<[ResultItem], Error>

protocol ListLoader {
    func load(completion: @escaping (ListResult) -> Void)
}
