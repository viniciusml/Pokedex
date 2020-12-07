//
//  RemotePokemonLoaderSpy.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
@testable import Pokedex

class RemotePokemonLoaderSpy: RemotePokemonLoader {
    private var completions = [(RemoteLoader<PokemonItem>.Result) -> Void]()
    
    var loadCallCount: Int {
        completions.count
    }
    
    override func load(from url: URL, completion: @escaping (RemoteLoader<PokemonItem>.Result) -> Void) {
        completions.append(completion)
    }
    
    func completeItemLoading(with pokemon: PokemonItem, at index: Int = 0) {
        completions[index](.success(pokemon))
    }
    
    func completeItemLoadingWithError(at index: Int) {
        completions[index](.failure(.connectivity))
    }
}
