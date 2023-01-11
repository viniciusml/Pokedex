//
//  DomainMacroTests.swift
//  PokemonDomainTests
//
//  Created by Vinicius Leal on 11/01/2023.
//  Copyright © 2023 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import XCTest

final class DomainMacroTests: XCTestCase {
    
    func testDebugBuild() {
        with(macro: UITestMacro.self) {
            XCTAssertEqual(HTTPClientType.current, .stubbed)
        }
    }
    
    func testProductionBuild() {
        XCTAssertEqual(HTTPClientType.current, .prod)
    }
    
    // MARK: - Helpers
    
    func with<T: Macro>(macro: T.Type, block: () -> Void) {
        macro.isOverridden = true
        block()
        macro.isOverridden = false
    }
}
