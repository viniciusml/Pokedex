//
//  PokeType.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 29/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

public struct RGB {
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
}

/// Enum representing possible Pokémon Types returned by the API, and a color according to each case.
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

    public var rgbColor: RGB {
        switch self {
        case .normal: return RGB(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.667)
        case .fighting: return RGB(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        case .flying: return RGB(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.667)
        case .poison: return RGB(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.333)
        case .ground: return RGB(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        case .rock: return RGB(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
        case .bug: return RGB(red: 0.0, green: 0.1, blue: 0.0, alpha: 1.0)
        case .ghost: return RGB(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
        case .steel: return RGB(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.333)
        case .fire: return RGB(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        case .water: return RGB(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .grass: return RGB(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .electric: return RGB(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        case .psychic: return RGB(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
        case .ice: return RGB(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .dragon: return RGB(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        case .dark: return RGB(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.333)
        case .fairy: return RGB(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
        case .unkown: return RGB(red: 0.07, green: 0.00, blue: 0.13, alpha: 1.0)
        case .shadow: return RGB(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
