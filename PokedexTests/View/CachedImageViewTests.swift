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
    
    override func setUp() {
        super.setUp()
        
        clearImageCache()
    }
    
    override func tearDown() {
        clearImageCache()
        
        super.tearDown()
    }
    
    func test_loadImage_withPlaceholder_showsPlaceholderOnURLCreationFailure() {
        let placeholderImage = makeImage()
        let (sut, _) = makeSUT(placeholderImage: placeholderImage)
        
        sut.loadImage(urlString: invalidURLString)
        
        XCTAssertEqual(sut.image, placeholderImage)
    }
    
    func test_loadImage_withoutPlaceholder_doesNotShowImageOnURLCreationFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(urlString: invalidURLString)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_deliversImageOnClientSuccess() {
        let (sut, client) = makeSUT()
        let (image, data) = UIImage.make(withColor: .red)
        
        sut.loadImage(urlString: validURLString)
        client.complete(withStatusCode: 200, data: data)
        
        XCTAssertEqual(sut.image?.pngData(), image.pngData())
    }
    
    func test_loadImage_withPlaceholder_showsPlaceholderOnClientFailure() {
        let placeholderImage = makeImage()
        let (sut, client) = makeSUT(placeholderImage: placeholderImage)
        
        sut.loadImage(urlString: validURLString)
        client.complete(with: anyNSError())
        
        XCTAssertEqual(sut.image, placeholderImage)
    }
    
    func test_loadImage_withoutPlaceholder_deliversNoImageOnClientFailure() {
        let (sut, client) = makeSUT()
        
        sut.loadImage(urlString: validURLString)
        client.complete(with: anyNSError())
        
        XCTAssertNil(sut.image)
    }
    
    func test_loadImage_withSuccess_savesImageToCache() {
        let (sut, client) = makeSUT()
        let (image, data) = UIImage.make(withColor: .red)
        
        sut.loadImage(urlString: validURLString)
        client.complete(withStatusCode: 200, data: data)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: validURLString as NSString)?.image
        XCTAssertEqual(cachedImage?.pngData(), image.pngData())
    }
    
    func test_loadImage_withPreviouslyCachedImage_doesNotLoadImageAgain() {
        let (sut, client) = makeSUT()
        let (image, data) = UIImage.make(withColor: .red)
        
        sut.loadImage(urlString: validURLString)
        client.complete(withStatusCode: 200, data: data)
        
        let cachedImage = CachedImageView.imageCache.object(forKey: validURLString as NSString)?.image
        XCTAssertEqual(cachedImage?.pngData(), image.pngData())
        
        sut.loadImage(urlString: validURLString)
        XCTAssertEqual(client.requestedURLs.count, 1)
        XCTAssertEqual(sut.image?.pngData(), image.pngData())
    }
    
    func test_loadImage_doesNotCompleteAfterSUTHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let loader = RemoteImageLoader(client: client)
        var sut: CachedImageView? = CachedImageView(loader: loader)
        let imageData = UIImage.make(withColor: .red).data
        
        sut?.loadImage(urlString: validURLString)
        sut = nil
        
        client.complete(withStatusCode: 200, data: imageData)
        XCTAssertNil(sut?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeholderImage: UIImage? = nil) -> (sut: CachedImageView, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let loader = RemoteImageLoader(client: client)
        let sut = CachedImageView(loader: loader, placeholderImage: placeholderImage)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(loader)
        return (sut, client)
    }
    
    private func makeImage() -> UIImage {
        UIImage.make(withColor: .black).image
    }
    
    private var validURLString: String {
        anyURL().absoluteString
    }
    
    private var invalidURLString: String {
        "any invalid url string"
    }
    
    private func clearImageCache() {
        CachedImageView.imageCache.removeAllObjects()
    }
}

extension UIImage {
    static func make(withColor color: UIColor) -> (image: UIImage, data: Data) {
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
