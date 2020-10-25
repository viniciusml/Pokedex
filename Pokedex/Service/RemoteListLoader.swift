//
//  RemoteListLoader.swift
//  Pokedex
//
//  Created by Vinicius Leal on 25/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public typealias RemoteListLoader = RemoteLoader<ListItem>

extension RemoteListLoader {
    convenience init(client: HTTPClient) {
        self.init(client: client, mapper: ListItemMapper.map)
    }
}
