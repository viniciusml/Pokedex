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
    
    func test_generatesIDFromRange() {
        let range = makeRange(min: 1, max: 10)
        
        (0...100).forEach { _ in
            let generatedID = generateID(from: range)
            XCTAssertTrue(range.contains(generatedID), "range does not contain expected generated ID: \(generatedID)")
        }
    }
    
    func test_generatedRandomID() {
        let range = makeRange(min: 1, max: 10)
        var firstTimeGeneratedIDs = [Int]()
        var secondTimeGeneratedIDs = [Int]()
        
        (0...10).forEach { _ in
            let generatedID = generateID(from: range)
            firstTimeGeneratedIDs.append(generatedID)
        }
        
        (0...10).forEach { _ in
            let generatedID = generateID(from: range)
            secondTimeGeneratedIDs.append(generatedID)
        }
        
        XCTAssertNotEqual(firstTimeGeneratedIDs, secondTimeGeneratedIDs)
    }
    
    // MARK: - Helpers
    
    private func generateID(from range: ClosedRange<Int>) -> Int {
        RandomIDProvider.generateID(from: range.first!, to: range.last!)
    }
    
    private func makeRange(min: Int, max: Int) -> ClosedRange<Int> {
        (min...max)
    }
}
