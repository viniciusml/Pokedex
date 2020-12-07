//
//  HTTPURLResponse+StatusCode.swift
//  Pokedex
//
//  Created by Vinicius Leal on 23/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        statusCode == HTTPURLResponse.OK_200
    }
}
