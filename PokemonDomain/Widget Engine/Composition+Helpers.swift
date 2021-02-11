//
//  Composition+Helpers.swift
//  PokemonDomain
//
//  Created by Vinicius Moreira Leal on 11/02/2021.
//  Copyright © 2021 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

typealias Operation<T, U> = ((T, ((U) -> Void)?) -> Void)?

infix operator >>->>: LogicalConjunctionPrecedence // Precedence of &&

func >>->><T, U, V>(lhs: Operation<T, U>, rhs: Operation<U, V>) -> Operation<T, V> {
    merge(lhs, to: rhs)
}

private func merge<T, U, V>(_ lhs: Operation<T, U>, to rhs: Operation<U, V>) -> Operation<T, V> {
    return { (input, completion) in
        lhs?(input) { output in
            rhs?(output, completion)
        }
    }
}
