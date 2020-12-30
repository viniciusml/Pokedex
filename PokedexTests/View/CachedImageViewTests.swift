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
        let client = HTTPClientSpy()
        let sut = CachedImageView(httpClient: client)
        let (image, data) = UIImage.make(withColor: .red)
        
        sut.loadImage(urlString: anyURL().absoluteString)
        client.complete(withStatusCode: 200, data: data)
        
        XCTAssertEqual(sut.image?.pngData(), image.pngData())
    }
    
    // Cover case where Data -> UIImage fails (should display placeholder if there's one, or nothing.
    
    // Cover case where Response is not 200 (should display placeholder if there's one, or nothing.
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
