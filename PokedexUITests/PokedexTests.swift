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

    override func setUp() {
        super.setUp()

        app.launchArguments.append("UITest")
        app.launch()
    }

    func testPokedex_firstPokemon() {
        let pokedexScreen = PokedexScreen(app)
        XCTAssertTrue(pokedexScreen.title.displayed)

        pokedexScreen.pokemonCell("Pokémon name: bulbasaur").tap()

        let pokemonDetailScreen = PokemonDetailsScreen(app)
        XCTAssertFalse(pokedexScreen.title.displayed)
        XCTAssertTrue(pokemonDetailScreen.pokemonIdentifier("Id: 1").exists)

        pokemonDetailScreen.pokemonSpriteContainer.swipeLeft()
        pokemonDetailScreen.pokemonSpriteContainer.swipeLeft()
        pokemonDetailScreen.pokemonSpriteContainer.swipeLeft()

        pokemonDetailScreen.backButton.tap()
        XCTAssertTrue(pokedexScreen.title.displayed)
    }
}

private extension XCUIElement {

    var displayed: Bool {
        guard exists, !frame.isEmpty else { return false }
        return exists && XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
}
