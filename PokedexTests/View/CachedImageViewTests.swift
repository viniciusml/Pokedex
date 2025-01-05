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

final class CachedImageViewTests: XCTestCase {
    
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
        
        sut.loadImage(url: invalidURL)
        
        assertImageDataEqual(sut.image, placeholderImage.image)
    }
    
    func test_loadImage_withoutPlaceholder_doesNotShowImageOnURLCreationFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(url: invalidURL)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_deliversImageOnClientSuccess() {
        let (sut, client) = makeSUT()
        let data = UIImage.makeImageData()
        
        sut.loadImage(url: anyURL())
        client.complete(withStatusCode: 200, data: data)
        
        assertImageDataEqual(sut.image, UIImage(data: data))
    }
    
    func test_loadImage_withPlaceholder_showsPlaceholderOnClientFailure() {
        let placeholderImage = makePlaceholderImage()
        let (sut, client) = makeSUT(placeholderImageName: placeholderImage.name)
        
        sut.loadImage(url: anyURL())
        client.complete(with: anyNSError())
        
        assertImageDataEqual(sut.image, placeholderImage.image)
    }
    
    func test_loadImage_withoutPlaceholder_deliversNoImageOnClientFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(url: anyURL())
        client.complete(with: anyNSError())
        
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_withSuccess_savesImageToCache() {
        let (sut, client) = makeSUT()
        let data = UIImage.makeImageData()
        let url = anyURL()
        
        sut.loadImage(url: url)
        client.complete(withStatusCode: 200, data: data)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: url.absoluteString as NSString)?.image
        assertImageDataEqual(cachedImage, UIImage(data: data))
    }
    
    func test_loadImage_withPreviouslyCachedImage_doesNotLoadImageAgain() {
        let (sut, client) = makeSUT()
        let data = UIImage.makeImageData()
        let url = anyURL()
        
        sut.loadImage(url: url)
        client.complete(withStatusCode: 200, data: data)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: url.absoluteString as NSString)?.image
        assertImageDataEqual(cachedImage, UIImage(data: data))
        
        sut.loadImage(url: anyURL())
        XCTAssertEqual(client.requestedURLs.count, 1)
        assertImageDataEqual(sut.image, UIImage(data: data))
    }
    
    func test_loadImage_doesNotCompleteAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let loader = RemoteImageLoader(client: client)
        var sut: CachedImageView? = CachedImageView(loader: loader)
        let imageData = UIImage.makeImageData()
        
        sut?.loadImage(url: anyURL())
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
    
    private func assertImageDataEqual(_ image1: UIImage?, _ image2: UIImage?, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(image1?.pngData(), image2?.pngData(), file: file, line: line)
    }
    
    private func makePlaceholderImage() -> (name: String, image: UIImage) {
        ("placeholder", MockImage(imageName: "placeholder")!)
    }
    
    private var invalidURL: URL? {
        nil
    }
    
    private func clearImageCache() {
        CachedImageView.imageCache.removeAllObjects()
    }
}

private final class MockImage: UIImage, @unchecked Sendable {
    convenience init?(imageName: String) {
        self.init(cgImage: UIImage(named: imageName)!.cgImage!)
    }
}
