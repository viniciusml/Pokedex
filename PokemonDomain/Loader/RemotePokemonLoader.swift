//
//  RemotePokemonLoader.swift
//  Pokedex
//
//  Created by Vinicius Leal on 25/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

public typealias RemotePokemonLoader = RemoteLoader<PokemonItem>

extension RemotePokemonLoader {
    public convenience init(client: HTTPClient) {
        self.init(client: client, mapper: PokemonItemMapper.map)
    }
}
