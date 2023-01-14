//
//  DomainMacro.swift
//  PokemonDomain
//
//  Created by Vinicius Leal on 11/01/2023.
//  Copyright © 2023 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public protocol Macro {
    static var isOverridden: Bool { get set }
}

public enum UITestMacro: Macro {
    public static var isOverridden = false
    
    static var active: Bool {
        #if UITEST
        return true
        #else
        return isOverridden
        #endif
    }
}

public protocol ConditionRepresentable: Equatable {}

public protocol TypeProviding {
    var current: any ConditionRepresentable { get }
}

public struct HTTPClientType: TypeProviding {
    
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
