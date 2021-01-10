//
//  ImageMapperTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import XCTest
import Pokedex

class ImageMapperTests: XCTestCase {
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidData() {
        XCTAssertThrowsError(
            try ImageMapper.map(invalidImageData)
        )
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithValidData() throws {
        let (image, data) = validImage
        
        let result = try ImageMapper.map(data)
        
        XCTAssertEqual(result.pngData(), image.pngData())
    }
    
    // MARK: - Helpers
    
    private var validImage: (image: UIImage, data: Data) {
        UIImage.make(withColor: .black)
    }
    
    private var invalidImageData: Data {
        Data("invalid json".utf8)
    }
}
