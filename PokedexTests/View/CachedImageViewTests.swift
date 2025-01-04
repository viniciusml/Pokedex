//
//  CachedImageViewTests.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 30/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Pokedex
import PokemonDomain
import XCTest

class CachedImageViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        clearImageCache()
    }
    
    override func tearDown() {
        clearImageCache()
        
        super.tearDown()
    }
    
    func test_loadImage_withPlaceholder_showsPlaceholderOnURLCreationFailure() {
        let placeholderImage = makePlaceholderImage()
        let (sut, _) = makeSUT(placeholderImageName: placeholderImage.name)
        
        sut.loadImage(urlString: invalidURLString, urlFactory: invalidURLFactory)
        
        XCTAssertEqual(sut.image?.pngData()!, placeholderImage.image.pngData()!)
    }
    
    func test_loadImage_withoutPlaceholder_doesNotShowImageOnURLCreationFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(urlString: invalidURLString, urlFactory: invalidURLFactory)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_deliversImageOnClientSuccess() {
        let (sut, client) = makeSUT()
        let data = UIImage.makeImageData()
        
        sut.loadImage(urlString: validURLString)
        client.complete(withStatusCode: 200, data: data)
        
        XCTAssertEqual(sut.image?.pngData(), UIImage(data: data)?.pngData())
    }
    
    func test_loadImage_withPlaceholder_showsPlaceholderOnClientFailure() {
        let placeholderImage = makePlaceholderImage()
        let (sut, client) = makeSUT(placeholderImageName: placeholderImage.name)
        
        sut.loadImage(urlString: validURLString)
        client.complete(with: anyNSError())
        
        XCTAssertEqual(sut.image?.pngData()!, placeholderImage.image.pngData()!)
    }
    
    func test_loadImage_withoutPlaceholder_deliversNoImageOnClientFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(urlString: validURLString)
        client.complete(with: anyNSError())
        
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_withSuccess_savesImageToCache() {
        let (sut, client) = makeSUT()
        let data = UIImage.makeImageData()
        
        sut.loadImage(urlString: validURLString)
        client.complete(withStatusCode: 200, data: data)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: validURLString as NSString)?.image
        XCTAssertEqual(cachedImage?.pngData(), UIImage(data: data)?.pngData())
    }
    
    func test_loadImage_withPreviouslyCachedImage_doesNotLoadImageAgain() {
        let (sut, client) = makeSUT()
        let data = UIImage.makeImageData()
        
        sut.loadImage(urlString: validURLString)
        client.complete(withStatusCode: 200, data: data)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: validURLString as NSString)?.image
        XCTAssertEqual(cachedImage?.pngData(), UIImage(data: data)?.pngData())
        
        sut.loadImage(urlString: validURLString)
        XCTAssertEqual(client.requestedURLs.count, 1)
        XCTAssertEqual(sut.image?.pngData(), UIImage(data: data)?.pngData())
    }
    
    func test_loadImage_doesNotCompleteAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let loader = RemoteImageLoader(client: client)
        var sut: CachedImageView? = CachedImageView(loader: loader)
        let imageData = UIImage.makeImageData()
        
        sut?.loadImage(urlString: validURLString)
        sut = nil
        
        client.complete(withStatusCode: 200, data: imageData)
        XCTAssertNil(sut?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeholderImageName: String = "") -> (sut: CachedImageView, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let loader = RemoteImageLoader(client: client)
        let sut = CachedImageView(loader: loader, placeholderImageName: placeholderImageName)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(loader)
        return (sut, client)
    }
    
    private func makePlaceholderImage() -> (name: String, image: UIImage) {
        ("placeholder", MockImage(imageName: "placeholder")!)
    }
    
    private var validURLString: String {
        anyURL().absoluteString
    }
    
    private var invalidURLString: String {
        "" // Empty strings are invalid URLs
    }
    
    private var invalidURLFactory: (String) -> URL? = { _ in
        nil
    }
    
    private func clearImageCache() {
        CachedImageView.imageCache.removeAllObjects()
    }
}

private class MockImage: UIImage, @unchecked Sendable {
    convenience init?(imageName: String) {
        self.init(cgImage: UIImage(named: imageName)!.cgImage!)
    }
}
