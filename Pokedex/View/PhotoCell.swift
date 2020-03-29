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
    
    let photoImageView: CachedImageView = {
        let photo = CachedImageView()
        return photo
    }()
        
    // MARK: - Helper functions
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
}
