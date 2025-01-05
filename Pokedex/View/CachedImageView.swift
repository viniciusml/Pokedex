//
//  CachedImageView.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public class DiscardableImageCacheItem: NSObject, NSDiscardableContent {

    private(set) public var image: UIImage?
    private var accessCount: UInt = 0

    public init(image: UIImage) {
        self.image = image
    }

    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }

        accessCount += 1
        return true
    }

    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }

    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }

    public func isContentDiscarded() -> Bool {
        image == nil
    }

}

/// UIImageView to load and cache images.
public class CachedImageView: UIImageView {

    private let loader: RemoteImageLoader
    public static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()
    
    private var placeholderImageName: String
    private lazy var placeholderImage: UIImage? = UIImage(named: placeholderImageName)
    
    public init(loader: RemoteImageLoader, placeholderImageName: String = "") {
        self.loader = loader
        self.placeholderImageName = placeholderImageName
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Load an image from a URL string and cache it to reduce network overhead.
    ///
    /// - parameter url: Image's url (optional).
    open func loadImage(url: URL?) {
        image = nil

        guard let url else {
            image = placeholderImage
            return
        }
        
        let urlKey = url.absoluteString as NSString

        if let cachedItem = CachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            return
        }

        loader.load(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(image):
                let cacheItem = DiscardableImageCacheItem(image: image)
                CachedImageView.imageCache.setObject(cacheItem, forKey: urlKey)
                self.image = image
            case .failure:
                self.image = self.placeholderImage
            }
        }
    }
}
