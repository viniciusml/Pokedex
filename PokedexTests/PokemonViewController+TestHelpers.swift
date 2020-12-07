//
//  PokemonViewController+TestHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

@testable import Pokedex

extension PokemonViewController {
    var pokemonName: String? {
        mainView.pokemonNameLabel.text
    }
    
    var pokemonID: String? {
        mainView.idLabel.text
    }
    
    var pokemonType: String? {
        mainView.typeLabel.text
    }
    
    var card: PokemonInfoView {
        mainView.infoCard
    }
    
    var pokemonAbilities: String? {
        card.abilitiesValueLabel.text
    }
    
    var pokemonStats: String? {
        card.statsValueLabel.text
    }
}
