//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    
    var id = ""
    
    var pokemonViewModel: PokemonViewModel!
    
    let mainView = PokemonMainView()
        
    convenience init(id: String) {
        self.init()
        self.id = id
        
        pokemonViewModel = PokemonViewModel(pokemonID: id, delegate: self)
        pokemonViewModel.fetchPokemon()
    }
    
    override func loadView() {
        view = mainView
    }
}

extension PokemonViewController: PokemonViewModelDelegate {
    
    func onFetchCompleted(pokemon: PokemonItem) {

        mainView.renderUI(with: pokemon)
    }
    
    func onFetchFailed(with reason: String) {
        debugPrint("🛑⚠️ \(reason) ⚠️🛑")
    }
}
