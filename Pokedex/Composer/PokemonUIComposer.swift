//
//  PokemonUIComposer.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public final class PokemonUIComposer {
    private init() {}
    
    public static func pokemonComposedWith(pokemonLoader: RemotePokemonLoader, imageLoader: RemoteImageLoader, urlString: String) -> PokemonViewController {
        let viewModel = PokemonViewModel(loader: pokemonLoader, pokemonURLString: urlString)
        let pokemonViewController = PokemonViewController(viewModel: viewModel)
        viewModel.onImageCheckCompleted = adaptURLStringToImageControllers(forwardingTo: pokemonViewController, using: imageLoader)
        return pokemonViewController
    }
    
    private static func adaptURLStringToImageControllers(forwardingTo controller: PokemonViewController, using loader: RemoteImageLoader) -> ([String]) -> Void {
        return { [weak controller, loader] urlStrings in
            controller?.imageControllers = urlStrings.map {
                PokemonImageViewController(imageURLString: $0, photoImageView: CachedImageView(loader: loader, placeholderImageName: .placeholder)) }
        }
    }
}

private extension String {
    static var placeholder: String {
        "placeholder"
    }
}
