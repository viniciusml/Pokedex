//
//  PhotoCell.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

/// Cell to be used as photo cell to be presented in PhotoCarousel.
///
/// Similar to UIPageViewController in appearence.
class PhotoCell: BaseCell {

    // MARK: - Properties

    static var identifier: String {
        return String(describing: self)
    }
    
    static var placeholder = UIImage(named: "placeholder")
    static var loader = RemoteImageLoader(client: AFHTTPClient())
    
    lazy var photoImageView: CachedImageView = {
        let photo = CachedImageView(loader: PhotoCell.loader, placeholderImage: PhotoCell.placeholder)
        return photo
    }()

    // MARK: - Helper functions

    override func setupViews() {
        super.setupViews()

        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
}
