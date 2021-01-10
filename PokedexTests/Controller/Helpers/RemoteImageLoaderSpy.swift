//
//  RemoteImageLoaderSpy.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit
@testable import Pokedex

class RemoteImageLoaderSpy: RemoteImageLoader {
    private var messages = [(url: URL, completion: (RemoteLoader<UIImage>.Result) -> Void)]()
    
    var loadCallCount: Int {
        messages.count
    }
    
    var url: URL? {
        messages.first?.url
    }
    
    override func load(from url: URL, completion: @escaping (RemoteLoader<UIImage>.Result) -> Void) {
        messages.append((url, completion))
    }
    
    func completeLoading(with image: UIImage) {
        messages.forEach { $0.completion(.success(image)) }
    }
    
    func completeLoadingWithError(at index: Int) {
        messages[index].completion(.failure(.connectivity))
    }
}
