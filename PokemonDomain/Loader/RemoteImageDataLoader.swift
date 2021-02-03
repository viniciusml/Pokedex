//
//  RemoteImageDataLoader.swift
//  PokemonDomain
//
//  Created by Vinicius Moreira Leal on 03/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public typealias RemoteImageDataLoader = RemoteLoader<Data>

extension RemoteImageDataLoader {
    public convenience init(client: HTTPClient) {
        self.init(client: client, mapper: DataMapper.map)
    }
}
