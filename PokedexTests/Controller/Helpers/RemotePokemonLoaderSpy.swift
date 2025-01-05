//
//  RemotePokemonLoaderSpy.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
@testable import PokemonDomain

final class RemotePokemonLoaderSpy: RemotePokemonLoader {
    private var messages = [(url: URL, completion: (RemoteLoader<PokemonItem>.Result) -> Void)]()
    
    var loadCallCount: Int {
        messages.count
    }
    
    var url: URL? {
        messages.first?.url
    }
    
    override func load(from url: URL, completion: @escaping (RemoteLoader<PokemonItem>.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func completeItemLoading(with pokemon: PokemonItem, at index: Int = 0) {
        messages[index].completion(.success(pokemon))
    }
    
    func completeItemLoadingWithError(at index: Int = 0) {
        messages[index].completion(.failure(.connectivity))
    }
}
