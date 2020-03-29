//
//  PhotoCell.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class PhotoCell: BaseCell {
        
    static var identifier: String {
        return String(describing: self)
    }
    
    let photoImageView: CachedImageView = {
        let photo = CachedImageView()
        return photo
    }()
        
    override func setupViews() {
        super.setupViews()
        
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
}
