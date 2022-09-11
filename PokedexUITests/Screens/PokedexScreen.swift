//
//  PokedexScreen.swift
//  PokedexUITests
//
//  Created by Vinicius Moreira Leal on 11/09/2022.
//  Copyright © 2022 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

struct PokedexScreen {
    private let app: XCUIApplication

    init(_ app: XCUIApplication) {
        self.app = app
    }

    var title: XCUIElement {
        app.staticTexts["Pokédex"]
    }

    func pokemonCell(_ identifier: String) -> XCUIElement {
        app.collectionViews.cells.containing(.staticText, identifier: identifier).element
    }
}
