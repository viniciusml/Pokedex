//
//  PokedexTests.swift
//  PokedexUITests
//
//  Created by Vinicius Moreira Leal on 11/09/2022.
//  Copyright © 2022 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

final class PokedexTests: XCTestCase {

    private let app = XCUIApplication()

    func testPokedex() {
        let pokedexScreen = PokedexScreen(app)

        XCTAssertTrue(pokedexScreen.title.displayed)
    }
}

extension XCUIElement {

    var displayed: Bool {
        guard exists, !frame.isEmpty else { return false }
        return exists && XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
}
