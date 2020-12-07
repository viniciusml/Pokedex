//
//  PokemonViewControllerTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Pokedex
import XCTest

class PokemonViewControllerTests: XCTestCase {
    
    func test_loadActions_requestsItemFromLoader() {
        let expectedURL = URL(string: "https://pokeapi.co/api/v2/pokemon/1")
        let (sut, loader) = makeSUT(urlString: "https://pokeapi.co/api/v2/pokemon/1")
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before the view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once the view is loaded")
        XCTAssertEqual(loader.url, expectedURL, "Expected loading request for correct url")
    }
    
    func test_loadItemCompletion_rendersSuccessfullyLoadedItem() {
        let item = makeItem(id: 1)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, hasViewConfiguredFor: .none)
        
        loader.completeItemLoading(with: item, at: 0)
        assertThat(sut, hasViewConfiguredFor: item)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(urlString: String = "https://pokeapi.co/api/v2/pokemon/1") -> (sut: PokemonViewController, loader: RemotePokemonLoaderSpy) {
        let client = HTTPClientSpy()
        let loader = RemotePokemonLoaderSpy(client: client)
        let viewModel = PokemonViewModel(loader: loader, pokemonURLString: urlString)
        let sut = PokemonViewController(viewModel: viewModel)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(viewModel)
        trackForMemoryLeaks(client)
        return (sut, loader)
    }
    
    private func makeItem(id: Int) -> PokemonItem {
        PokemonItem(id: id,
                    name: "bulbasaur",
                    baseExperience: 64,
                    height: 7,
                    isDefault: true,
                    order: 1,
                    weight: 69,
                    abilities: [
                        Ability(isHidden: true,
                                slot: 3,
                                ability: Species(name: "chlorophyll",
                                                 url: "https://pokeapi.co/api/v2/ability/34/"))],
                    forms: [Species(name: "bulbasaur",
                                    url: "https://pokeapi.co/api/v2/pokemon-form/1/")],
                    species: Species(name: "bulbasaur",
                                     url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
                    sprites: Sprites(backFemale: nil,
                                     backShinyFemale: nil,
                                     backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                                     frontFemale: nil,
                                     frontShinyFemale: nil,
                                     backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
                                     frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                                     frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"),
                    stats: [Stat(baseStat: 45,
                                 effort: 0,
                                 stat: Species(name: "speed",
                                               url: "https://pokeapi.co/api/v2/stat/6/"))],
                    types: [TypeElement(slot: 2,
                                        type: Species(name: "poison",
                                                      url: "https://pokeapi.co/api/v2/type/4/"))])
    }
    
    // TODO replace #file
    private func assertThat(_ sut: PokemonViewController, hasViewConfiguredFor item: PokemonItem?, file: StaticString = #file, line: UInt = #line) {
        
        XCTAssertEqual(sut.pokemonName, item?.formattedName, "Expected name text to be \(String(describing: item?.name)) for label", file: file, line: line)
        XCTAssertEqual(sut.pokemonID, item?.formattedID, "Expected id text to be \(String(describing: item?.id)) for label", file: file, line: line)
        XCTAssertEqual(sut.pokemonType, item?.formattedType, "Expected type text to be \(String(describing: item?.name)) for label", file: file, line: line)
        XCTAssertEqual(sut.pokemonBackgroundColor, item?.backgroundColor, "Expected background color to be \(String(describing: item?.backgroundColor)) for view", file: file, line: line)
        XCTAssertEqual(sut.pokemonStats, item?.formattedStats, "Expected stats text to be \(String(describing: item?.formattedStats)) for label", file: file, line: line)
        XCTAssertEqual(sut.pokemonAbilities, item?.formattedAbilities, "Expected abilities text to be \(String(describing: item?.formattedAbilities)) for label", file: file, line: line)
    }
}
