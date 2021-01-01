//
//  CachedImageView.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

open class DiscardableImageCacheItem: NSObject, NSDiscardableContent {

    private(set) public var image: UIImage?
    var accessCount: UInt = 0

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
        return image == nil
    }

}

/// UIImageView to load and cache images.
open class CachedImageView: UIImageView {

    public static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()

    private var urlStringForChecking: String?
    private var placeholderImage: UIImage?
    
    private let loader: RemoteImageLoader

    public init(loader: RemoteImageLoader, placeholderImage: UIImage? = nil) {
        self.loader = loader
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        self.placeholderImage = placeholderImage
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Load an image from a URL string and cache it to reduce network overhead.
    ///
    /// - parameter urlString: Image's url.

    open func loadImage(urlString: String) {
        image = nil

        self.urlStringForChecking = urlString

        let urlKey = urlString as NSString

        if let cachedItem = CachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            return
        }

        guard let url = URL(string: urlString) else {
            image = placeholderImage
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
        
        URLSession.shared.dataTask(
            with: url,
            completionHandler: { [weak self] (data, response, error) in
                if error != nil {
                    return
                }

                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        let cacheItem = DiscardableImageCacheItem(image: image)
                        CachedImageView.imageCache.setObject(cacheItem, forKey: urlKey)

                        if urlString == self?.urlStringForChecking {
                            self?.image = image
                        }
                    }
                }

            }
        ).resume()
    }
}

extension CachedImageView {
    convenience init() {
        self.init(loader: RemoteImageLoader(client: AFHTTPClient()))
    }
}
