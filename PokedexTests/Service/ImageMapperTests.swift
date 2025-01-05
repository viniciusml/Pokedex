//
//  ImageMapperTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

final class ImageMapperTests: XCTestCase {
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidData() {
        XCTAssertThrowsError(
            try ImageMapper.map(invalidImageData)
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithValidData() throws {
        let data = validImageData
        
        let result = try ImageMapper.map(data)
        
        XCTAssertEqual(result.pngData(), UIImage(data: data)?.pngData())
    }
    
    // MARK: - Helpers
    
    private var validImageData: Data {
        UIImage.makeImageData()
    }
    
    private var invalidImageData: Data {
        Data("invalid json".utf8)
    }
}
