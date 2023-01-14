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
