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
        let sut = HTTPClientTypeProvider()
        
        with(macro: UITestMacro.self) {
            assertCurrent(in: sut, equalTo: HTTPClientTypeProvider.Condition.stubbed)
        }
    }
    
    func testProductionBuild() {
        let sut = HTTPClientTypeProvider()
        
        assertCurrent(in: sut, equalTo: HTTPClientTypeProvider.Condition.prod)
    }
    
    // MARK: - Helpers
    
    private func with<T: Macro>(macro: T.Type, block: () -> Void) {
        macro.isOverridden = true
        block()
        macro.isOverridden = false
    }
    
    private func assertCurrent<T: ConditionRepresentable>(in typeProvider: TypeProviding, equalTo expectedValue: T) {
        
        XCTAssertEqual(typeProvider.current as? T, expectedValue)
    }
}
