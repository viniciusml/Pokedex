//
//  PokemonDetailsScreen.swift
//  PokedexUITests
//
//  Created by Vinicius Moreira Leal on 11/09/2022.
//  Copyright © 2022 Vinicius Moreira Leal. All rights reserved.
//

import XCTest

struct PokemonDetailsScreen {
    private let app: XCUIApplication

    init(_ app: XCUIApplication) {
        self.app = app
    }

    var pokemonSpriteContainer: XCUIElement {
        app.scrollViews.otherElements.images["Pokémon sprite"]
    }

    var backButton: XCUIElement {
        app.navigationBars["Pokédex"].buttons["Pokédex"]
    }

    func pokemonIdentifier(_ identifier: String) -> XCUIElement {
        app.staticTexts[identifier]
    }
}
