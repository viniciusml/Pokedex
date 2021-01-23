//
//  PokedexSnapshotTests.swift
//  PokedexSnapshotTests
//
//  Created by Vinicius Moreira Leal on 10/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import AccessibilitySnapshot
import Pokedex
import PokemonDomain
import SnapshotTesting
import XCTest

class PokedexSnapshotTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        cleanImageViewCache()
    }
    
    override func tearDown() {
        cleanImageViewCache()
        super.tearDown()
    }

    func test_listViewController_withSuccessfulResponse() {
        assertSnapshot(matching: makeListViewController(.online([.listData])), as: .image(on: .iPhoneXr))
    }
    
    func test_listViewController_withUnsuccessfulResponse() {
        assertSnapshot(matching: makeListViewController(.offline), as: .image(on: .iPhoneXr))
    }
    
    func test_listViewController_whileWaitingResponse() {
        assertSnapshot(matching: makeListViewController(.loading), as: .image(on: .iPhoneXr))
    }
    
    func test_listViewController_whileWaitingResponse_accessibilityElements() throws {
        try XCTSkipIf(UIDevice.isIphone12Pro, "Skipped on CI")
        assertSnapshot(matching: makeListViewController(.loading), as: .accessibilityImage)
    }
    
    func test_pokemonViewController_withSuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.online([.pokemonData, .pokemonImageData])), as: .image(on: .iPhoneXr))
    }
    
    func test_pokemonViewController_withImagePlaceholder_withSuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.online([.pokemonData, .pokemonInvalidImageData])), as: .image(on: .iPhoneXr))
    }
    
    func test_pokemonViewController_withSuccessfulResponse_accessibilityElements() throws {
        try XCTSkipIf(UIDevice.isIphone12Pro, "Skipped on CI")
        assertSnapshot(matching: makePokemonViewController(.online([.pokemonData, .pokemonImageData])), as: .accessibilityImage(drawHierarchyInKeyWindow: true))
    }
    
    func test_pokemonViewController_withUnsuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.offline), as: .image(on: .iPhoneXr))
    }
    
    // MARK: - Helpers
    
    private func makeListViewController(_ state: HTTPClientStub.State) -> NavigationController {
        let client = HTTPClientStub(state)
        let listLoader = RemoteListLoader(client: client)
        let viewController = ResourceListUIComposer.resourceListComposedWith(listLoader: listLoader, selection: { _ in })
        let navigationController = NavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func makePokemonViewController(_ state: HTTPClientStub.State, placeholder: Bool = false) -> NavigationController {
        let client = HTTPClientStub(state)
        let pokemonLoader = RemotePokemonLoader(client: client)
        let imageLoader = RemoteImageLoader(client: client)
        let viewController = PokemonUIComposer.pokemonComposedWith(
            pokemonLoader: pokemonLoader,
            imageLoader: imageLoader,
            urlString: "https://pokeapi.co/api/v2/pokemon/1")
        let navigationController = NavigationController(rootViewController: UIViewController())
        navigationController.pushViewController(viewController, animated: false)
        return navigationController
    }
    
    private func cleanImageViewCache() {
        CachedImageView.imageCache.removeAllObjects()
    }
    
    private class HTTPClientStub: HTTPClient {
        enum State {
            case online([Data]), offline, loading
        }
        
        let state: State
        
        init(_ state: State) {
            self.state = state
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            switch state {
            case let .online(data):
                data.forEach { completion(.success(($0, makeResponse()))) }
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
    
    static var pokemonImageData: Data {
        UIImage.makeImageData()
    }
    
    static var pokemonInvalidImageData: Data {
        Data("any data".utf8)
    }
}

extension UIDevice {
    static var isIphone12Pro: Bool {
        modelIdentifier() == "iPhone13,3" // iPhone 12 Pro model identifier
    }
    
    // https://www.theiphonewiki.com/wiki/Models
    private static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
