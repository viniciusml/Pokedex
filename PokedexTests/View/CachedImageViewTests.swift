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
        let (sut, loader) = makeSUT()
        
        sut.loadImage(url: invalidURL)
        
        XCTAssertEqual(loader.loadCallCount, 0)
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_deliversImageOnLoaderSuccess() {
        let (sut, loader) = makeSUT()
        let expectedImage = UIImage.make(withColor: .red)
        
        sut.loadImage(url: anyURL())
        loader.completeLoading(with: expectedImage)
        
        assertImageDataEqual(sut.image, expectedImage)
    }
    
    func test_loadImage_withPlaceholder_showsPlaceholderOnLoaderFailure() {
        let placeholderImage = makePlaceholderImage()
        let (sut, loader) = makeSUT(placeholderImageName: placeholderImage.name)
        
        sut.loadImage(url: anyURL())
        loader.completeLoadingWithError(at: 0)
        
        assertImageDataEqual(sut.image, placeholderImage.image)
    }
    
    func test_loadImage_withoutPlaceholder_deliversNoImageOnLoaderFailure() {
        let (sut, loader) = makeSUT()
        
        sut.loadImage(url: anyURL())
        loader.completeLoadingWithError(at: 0)
        
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_withSuccess_savesImageToCache() {
        let (sut, loader) = makeSUT()
        let expectedImage = UIImage.make(withColor: .blue)
        let url = anyURL()
        
        sut.loadImage(url: url)
        loader.completeLoading(with: expectedImage)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: url.absoluteString as NSString)?.image
        assertImageDataEqual(cachedImage, expectedImage)
    }
    
    func test_loadImage_withPreviouslyCachedImage_doesNotLoadImageAgain() {
        let (sut, loader) = makeSUT()
        let expectedImage = UIImage.make(withColor: .red)
        let url = anyURL()
        
        sut.loadImage(url: url)
        loader.completeLoading(with: expectedImage)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: url.absoluteString as NSString)?.image
        assertImageDataEqual(cachedImage, expectedImage)
        
        sut.loadImage(url: anyURL())
        XCTAssertEqual(loader.loadCallCount, 1)
        assertImageDataEqual(sut.image, expectedImage)
    }
    
    func test_loadImage_doesNotCompleteAfterSUTHasBeenDeallocated() {
        let loader = RemoteImageLoaderSpy(client: HTTPClientSpy())
        var sut: CachedImageView? = CachedImageView(loader: loader)
        let image = UIImage.make(withColor: .black)
        
        sut?.loadImage(url: anyURL())
        sut = nil
        
        loader.completeLoading(with: image)
        XCTAssertNil(sut?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeholderImageName: String = "") -> (sut: CachedImageView, loader: RemoteImageLoaderSpy) {
        let client = HTTPClientSpy()
        let loader = RemoteImageLoaderSpy(client: client)
        let sut = CachedImageView(loader: loader, placeholderImageName: placeholderImageName)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(loader)
        return (sut, loader)
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
