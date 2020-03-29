//
//  PokeType.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public enum PokeType: Int {
    case normal = 1
    case fighting = 2
    case flying = 3
    case poison = 4
    case ground = 5
    case rock = 6
    case bug = 7
    case ghost = 8
    case steel = 9
    case fire = 10
    case water = 11
    case grass = 12
    case electric = 13
    case psychic = 14
    case ice = 15
    case dragon = 16
    case dark = 17
    case fairy = 18
    case unkown = 10001
    case shadow = 10002
    
    var color: UIColor {
        switch self {
        case .normal: return .lightGray
        case .fighting: return .orange
        case .flying: return .lightGray
        case .poison: return .darkGray
        case .ground: return .brown
        case .rock: return .brown
        case .bug: return .green
        case .ghost: return .purple
        case .steel: return .darkGray
        case .fire: return .red
        case .water: return .blue
        case .grass: return .green
        case .electric: return .orange
        case .psychic: return .purple
        case .ice: return .cyan
        case .dragon: return .orange
        case .dark: return .darkGray
        case .fairy: return .magenta
        case .unkown: return .cellColor
        case .shadow: return .white
        }
    }
}
