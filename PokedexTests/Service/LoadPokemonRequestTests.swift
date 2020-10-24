//
//  LoadPokemonRequestTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 28/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

//class LoadPokemonRequestTests: XCTestCase {
//    
//    private let item = PokemonItem(id: 1,
//                                   name: "bulbasaur",
//                                   baseExperience: 64,
//                                   height: 7,
//                                   isDefault: true,
//                                   order: 1,
//                                   weight: 69,
//                                   abilities: [
//                                    Ability(isHidden: true,
//                                            slot: 3,
//                                            ability: Species(name: "chlorophyll",
//                                                             url: "https://pokeapi.co/api/v2/ability/34/"))],
//                                   forms: [Species(name: "bulbasaur",
//                                                   url: "https://pokeapi.co/api/v2/pokemon-form/1/")],
//                                   species: Species(name: "bulbasaur",
//                                                    url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
//                                   sprites: Sprites(backFemale: nil,
//                                                    backShinyFemale: nil,
//                                                    backDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
//                                                    frontFemale: nil,
//                                                    frontShinyFemale: nil,
//                                                    backShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
//                                                    frontDefault: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
//                                                    frontShiny: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"),
//                                   stats: [Stat(baseStat: 45,
//                                                effort: 0,
//                                                stat: Species(name: "speed",
//                                                              url: "https://pokeapi.co/api/v2/stat/6/"))],
//                                   types: [TypeElement(slot: 2,
//                                                       type: Species(name: "poison",
//                                                                     url: "https://pokeapi.co/api/v2/type/4/"))])
//    
//    func test_load_requestDataFromURL() {
//        let (sut, client) = makeSUT()
//        
//        sut.loadPokemon() { _ in }
//        
//        XCTAssertEqual(client.requestedURLs, [baseURL()])
//    }
//    
//    func test_load_deliversItemsOn200HTTPResponse() {
//        let (sut, client) = makeSUT()
//        
//        expect(sut, toCompleteWith: .success(item), when: {
//            client.complete(withValue: item)
//        })
//    }
//    
//    func test_load_usesPageParameter() {
//        let (sut, client) = makeSUT()
//        let id = "1"
//        
//        sut.loadPokemon(pokemonId: id) { _ in }
//        
//        XCTAssertEqual(client.requestedURLs, [baseURL() + id])
//    }
//    
//    // MARK: - Helpers
//    
//    private func expect(_ sut: RemoteLoader, toCompleteWith result: RequestResult<PokemonItem>, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
//        var capturedResult = [RequestResult<PokemonItem>]()
//        sut.loadPokemon { capturedResult.append($0) }
//        
//        action()
//        
//        XCTAssertEqual(capturedResult, [result], file: file, line: line)
//    }
//
//    func makeSUT() -> (sut: RemoteLoader, client: HTTPClientSpy<PokemonItem>) {
//        let client = HTTPClientSpy<PokemonItem>()
//        let sut = RemoteLoader(client: client)
//        return (sut, client)
//    }
//}
