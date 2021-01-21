//
//  RGB+Extension.swift
//  Pokedex
//
//  Created by Vinicius Moreira Leal on 21/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import UIKit

extension RGB {
    var toUIColor: UIColor {
        UIColor(red: red.cg, green: green.cg, blue: blue.cg, alpha: alpha.cg)
    }
}

private extension Float {
    var cg: CGFloat {
        CGFloat(self)
    }
}

