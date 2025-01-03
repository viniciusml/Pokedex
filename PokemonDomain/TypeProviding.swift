//
//  TypeProviding.swift
//  PokemonDomain
//
//  Created by Vinicius Leal on 14/01/2023.
//  Copyright © 2023 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public protocol ConditionRepresentable: Equatable {}

public protocol TypeProviding {
    var current: any ConditionRepresentable { get }
}

public struct HTTPClientTypeProvider: TypeProviding {
    
    public enum Condition: ConditionRepresentable {
        case prod
        case stubbed
    }
    
    public init() {}
    
    public var current: any ConditionRepresentable {
        if UITestMacro.active {
            return Condition.stubbed
        } else {
            return Condition.prod
        }
    }
}
