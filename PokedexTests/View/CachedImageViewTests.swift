//
//  CachedImageViewTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 30/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Pokedex
import XCTest

class CachedImageViewTests: XCTestCase {
    
    func test_loadImage_deliversImageOnClientSuccess() {
        let (sut, client) = makeSUT()
        let (image, data) = UIImage.make(withColor: .red)
        
        sut.loadImage(urlString: anyURL().absoluteString)
        client.complete(withStatusCode: 200, data: data)
        
        XCTAssertEqual(sut.image?.pngData(), image.pngData())
    }
    
    func test_loadImage_withoutPlaceholder_deliversNoImageOnClientFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(urlString: anyURL().absoluteString)
        client.complete(with: anyNSError())
        
        XCTAssertNil(sut.image)
    }
    
    // Cover case where Data -> UIImage fails (should display placeholder if there's one, or nothing.
    
    // Cover case where Response is not 200 (should display placeholder if there's one, or nothing.
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: CachedImageView, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = CachedImageView(httpClient: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
}

extension UIImage {
    static func make(withColor color: UIColor) -> (UIImage, Data) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (img!, img!.pngData()!)
    }
}
