//
//  RemoteChosenPokemonLoader+Helper.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain

extension RemoteChosenPokemonLoader {
    
    static func makeLoader() -> RemoteChosenPokemonLoader {
        let client = AFHTTPClient()
        let listLoader = RemoteListLoader(client: client)
        let pokemonLoader = RemotePokemonLoader(client: client)
        let imageDataLoader = RemoteImageDataLoader(client: client)
        let randomIDProvider = RandomIDProvider()
        
        return RemoteChosenPokemonLoader(
            listLoader: listLoader,
            pokemonLoader: pokemonLoader,
            imageDataLoader: imageDataLoader,
            idProvider: randomIDProvider)
    }
}
