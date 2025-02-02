//
//  PokemonImageViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

final class PokemonImageViewController: UIViewController {
    
    private let photoImageView: CachedImageView
    let imageURLString: String
    
    init(imageURLString: String, photoImageView: CachedImageView = CachedImageView()) {
        self.imageURLString = imageURLString
        self.photoImageView = photoImageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        photoImageView.configureAccessibility()
        view.addSubview(photoImageView)
        photoImageView.fillSuperview()
        
        photoImageView.loadImage(url: URL(string: imageURLString))
    }
}

private extension CachedImageView {
    func configureAccessibility() {
        isAccessibilityElement = true
        accessibilityLabel = "Pokémon sprite"
    }
}
