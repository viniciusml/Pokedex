//
//  PokemonImageViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 01/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class PokemonImageViewController: UIViewController {
    
    private let photoImageView: CachedImageView = {
        let photo = CachedImageView()
        return photo
    }()
    
    override func viewDidLoad() {
        
        view.addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
    
    public func loadImage(from urlString: String) {
        photoImageView.loadImage(urlString: urlString)
    }
}
