//
//  PokemonItem+TestHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Moreira Leal on 07/12/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit
@testable import Pokedex

extension PokemonItem {
    var formattedName: String {
        name.capitalized
    }
    
    var formattedID: String {
        "#\(id)"
    }
    
    var formattedType: String? {
        types.first?.type.name.capitalized
    }
    
    var backgroundColor: UIColor? {
        types.first?.typeID()?.rgbColor.toUIColor
    }
    
    var formattedStats: String {
        stats.map { $0.stat.name }.joined(separator: ", ").capitalized
    }
    
    var formattedAbilities: String {
        abilities.map { $0.ability.name }.joined(separator: ", ").capitalized
    }
    
    var availableImagesURLString: [String] {
        [sprites.frontDefault,
         sprites.frontFemale,
         sprites.frontShiny,
         sprites.frontShinyFemale,
         sprites.backDefault,
         sprites.backFemale,
         sprites.backShiny,
         sprites.backShinyFemale]
            .compactMap { $0 }
    }
    
    var photoCount: Int {
        availableImagesURLString.count
    }
}
