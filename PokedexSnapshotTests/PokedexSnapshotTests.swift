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

private final class PokedexSnapshotTests: XCTestCase { // Skipped until snapshot testing can be revisited
    
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
        try XCTSkipIf(UIDevice.isIphone13Pro, "Skipped on CI")
        assertSnapshot(matching: makeListViewController(.loading), as: .accessibilityImage)
    }
    
    func test_pokemonViewController_withSuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.online([.pokemonData, .pokemonImageData])), as: .image(on: .iPhoneXr))
    }
    
    func test_pokemonViewController_withImagePlaceholder_withSuccessfulResponse() {
        assertSnapshot(matching: makePokemonViewController(.online([.pokemonData, .pokemonInvalidImageData])), as: .image(on: .iPhoneXr))
    }
    
    func test_pokemonViewController_withSuccessfulResponse_accessibilityElements() throws {
        try XCTSkipIf(UIDevice.isIphone13Pro, "Skipped on CI")
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
}

extension UIDevice {
    static var isIphone13Pro: Bool {
        modelIdentifier() == "iPhone14,2" // iPhone 13 Pro model identifier
    }
    
    // https://www.theiphonewiki.com/wiki/Models
    private static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
