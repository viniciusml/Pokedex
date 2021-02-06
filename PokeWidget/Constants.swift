//
//  Constants.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 06/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import SwiftUI

extension Font {
    static let medium = Font.custom("Futura-Medium", size: 16)
}

extension UIColor {
    static let defaultRed = UIColor(red: 251 / 255, green: 109 / 255, blue: 108 / 255, alpha: 0.4)
}

extension UIImage {
    static let placeholder = UIImage(named: "placeholder")!
    
    static func imageWith(_ data: Data) -> UIImage {
        UIImage(data: data) ?? placeholder
    }
}
