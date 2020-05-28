//
//  Router.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 28/05/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public protocol Router {
    func routeTo(pokemon urlString: String)
}
