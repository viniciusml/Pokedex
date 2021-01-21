//
//  RemoteListLoaderSpy.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 06/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
@testable import Pokedex
import PokemonDomain

class RemoteListLoaderSpy: RemoteListLoader {
    private var completions = [(RemoteLoader<ListItem>.Result) -> Void]()
    
    var loadCallCount: Int {
        completions.count
    }
    
    override func load(from url: URL, completion: @escaping (RemoteLoader<ListItem>.Result) -> Void) {
        completions.append(completion)
    }
    
    func completeListLoading(with list: ListItem, at index: Int = 0) {
        completions[index](.success(list))
    }
    
    func completeListLoadingWithError(at index: Int) {
        completions[index](.failure(.connectivity))
    }
}
