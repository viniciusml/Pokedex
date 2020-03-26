//
//  ListLoader.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 26/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public class ListLoader {
    let client: NetworkAdapter
    let url: URL
    
    public init(url: URL, client: NetworkAdapter) {
        self.client = client
        self.url = url
    }
    
    public func loadResourceList() {
        client.load(from: url) { _ in }
    }
}
