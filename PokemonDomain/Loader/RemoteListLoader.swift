//
//  RemoteListLoader.swift
//  Pokedex
//
//  Created by Vinicius Leal on 25/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

public typealias RemoteListLoader = RemoteLoader<ListItem>

extension RemoteListLoader {
    public convenience init(client: HTTPClient) {
        self.init(client: client, mapper: ListItemMapper.map)
    }
}
