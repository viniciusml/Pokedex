//
//  PokedexSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by Vinicius Moreira Leal on 10/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import AccessibilitySnapshot
import Pokedex
import SnapshotTesting
import XCTest

class PokedexSnapshotTests: XCTestCase {

    func test_listViewController_withSuccessfulResponse() {
        assertSnapshot(matching: makeListViewController(.online(.listData)), as: .image(on: .iPhoneXr))
    }
    
    func test_listViewController_withUnsuccessfulResponse() {
        assertSnapshot(matching: makeListViewController(.offline), as: .image(on: .iPhoneXr))
    }
    
    func test_listViewController_whileWaitingResponse() {
        assertSnapshot(matching: makeListViewController(.loading), as: .image(on: .iPhoneXr))
    }
    
    func test_listViewController_whileWaitingResponse_accessibilityElements() {
        assertSnapshot(matching: makeListViewController(.loading), as: .accessibilityImage)
    }
    
    func test_pokemonViewController_withSuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.online(.pokemonData)), as: .image(on: .iPhoneXr))
    }
    
    func test_pokemonViewController_withSuccessfulResponse_accessibilityElements() {
        assertSnapshot(matching: makePokemonViewController(.online(.pokemonData)), as: .accessibilityImage(drawHierarchyInKeyWindow: true))
    }
    
    func test_pokemonViewController_withUnsuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.offline), as: .image(on: .iPhoneXr))
    }
    
    // MARK: - Helpers
    
    private func makeListViewController(_ state: HTTPClientStub.State) -> ResourceListCollectionViewController {
        let client = HTTPClientStub(state)
        let listLoader = RemoteListLoader(client: client)
        let viewController = ResourceListUIComposer.resourceListComposedWith(listLoader: listLoader, selection: { _ in })
        return viewController
    }
    
    private func makePokemonViewController(_ state: HTTPClientStub.State) -> PokemonViewController {
        let client = HTTPClientStub(state)
        let pokemonLoader = RemotePokemonLoader(client: client)
        let viewController = PokemonUIComposer.pokemonComposedWith(pokemonLoader: pokemonLoader, urlString: "https://pokeapi.co/api/v2/pokemon/1")
        return viewController
    }
    
    private class HTTPClientStub: HTTPClient {
        enum State {
            case online(Data), offline, loading
        }
        
        let state: State
        
        init(_ state: State) {
            self.state = state
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            switch state {
            case let .online(data):
                completion(.success((data, makeResponse())))
            case .offline:
                completion(.failure(anyNSError()))
            case .loading:
                return
            }
        }
        
        private func makeResponse() -> HTTPURLResponse {
            HTTPURLResponse(url: URL(string: "http://next-url.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        }
        
        func anyNSError() -> NSError {
            NSError(domain: "any error", code: 0)
        }
    }
}

fileprivate extension Data {
    static var listData: Data {
        let json = [
            "count": 200,
            "next": "http://next-url.com",
            "previous": nil,
            "results": [
                ["name": "name1",
                 "url": "http://a-url.com"],
                ["name": "name2",
                 "url": "http://a-url.com"],
                ["name": "name3",
                 "url": "http://a-url.com"],
                ["name": "name4",
                 "url": "http://a-url.com"],
                ["name": "name5",
                 "url": "http://a-url.com"],
                ["name": "name6",
                 "url": "http://a-url.com"],
                ["name": "name7",
                 "url": "http://a-url.com"],
                ["name": "name8",
                 "url": "http://a-url.com"]
            ]
        ].compactMapValues { $0 }
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    static var pokemonData: Data {
        let json = [
            "id": 1,
            "name": "bulbasaur",
            "base_experience": 64,
            "height": 7,
            "is_default": true,
            "order": 1,
            "weight": 69,
            "abilities": [[
                            "is_hidden": true,
                            "slot": 3,
                            "ability": ["name": "chlorophyll",
                                        "url": "https://pokeapi.co/api/v2/ability/34/"]]],
            "forms": [["name": "bulbasaur",
                       "url": "https://pokeapi.co/api/v2/pokemon-form/1/"]],
            "species": ["name": "bulbasaur",
                        "url": "https://pokeapi.co/api/v2/pokemon-species/1/"],
            "sprites": ["back_female": nil,
                        "back_shiny_female": nil,
                        "back_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                        "front_female": nil,
                        "front_shiny_female": nil,
                        "back_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png",
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
                        "front_shiny": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png"],
            "stats": [["base_stat": 45,
                       "effort": 0,
                       "stat": ["name": "speed",
                                "url": "https://pokeapi.co/api/v2/stat/6/"]]],
            "types": [["slot": 2,
                       "type": ["name": "poison",
                                "url": "https://pokeapi.co/api/v2/type/4/"]]]
        ].compactMapValues { $0 }
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
