//
//  RandomIDProvider.swift
//  PokeWidgetEngine
//
//  Created by Vinicius Moreira Leal on 31/01/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

public struct RandomIDProvider: IDProvider {
    
    public init() {}
    
    public func generateID(from min: Int, to max: Int) -> Int {
        Int.random(in: min...max)
    }
}
