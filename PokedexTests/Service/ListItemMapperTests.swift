//
//  ListItemMapperTests.swift
//  PokedexTests
//
//  Created by Vinicius Leal on 24/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ListItemMapperTests: XCTestCase {
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try ListItemMapper.map(invalidJSON)
        )
    }
    
    func test_map_deliversErrorOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([:])
        
        XCTAssertThrowsError(
            try ListItemMapper.map(emptyListJSON)
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let item = makeItem(
            count: 3,
            next: "http://next-url.com",
            previous: nil,
            name: "a name",
            url: "http://a-url.com")
        
        let json = makeItemsJSON(item.json)
        
        let result = try ListItemMapper.map(json)
        
        XCTAssertEqual(result, item.model)
    }
    
    // MARK: - Helpers
    
    private func makeItem(count: Int, next: String, previous: String? = nil, name: String, url: String) -> (model: ListItem, json: [String: Any]) {
        
        let item = ListItem(
            count: count,
            next: next,
            previous: previous,
            results: [ResultItem(
                        name: name,
                        url: url)])
        
        let json = [
            "count": count,
            "next": next,
            "previous": previous as Any,
            "results": [[
                "name": name,
                "url": url
            ]]
        ].compactMapValues { $0 }
        
        return (item, json)
    }
}
