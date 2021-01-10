//
//  RemoteImageLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public typealias RemoteImageLoader = RemoteLoader<UIImage>

extension RemoteImageLoader {
    public convenience init(client: HTTPClient) {
        self.init(client: client, mapper: ImageMapper.map)
    }
}
