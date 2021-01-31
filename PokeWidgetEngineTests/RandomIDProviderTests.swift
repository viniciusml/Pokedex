//
//  RandomIDProviderTests.swift
//  PokeWidgetEngineTests
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokeWidgetEngine
import XCTest

class RandomIDProviderTests: XCTestCase {
    
    func test_provideID_generatedIDFromRange() {
        let generatedID = RandomIDProvider.generateID(from: 1, to: 10)
        
        XCTAssertTrue((1...10).contains(generatedID))
    }
}
