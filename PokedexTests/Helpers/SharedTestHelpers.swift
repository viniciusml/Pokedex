//
//  SharedTestHelpers.swift
//  PokedexTests
//
//  Created by Vinicius Leal on 24/10/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

func anyData() -> Data {
    Data("any data".utf8)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func makeItemsJSON(_ items: [String: Any]) -> Data {
    try! JSONSerialization.data(withJSONObject: items)
}
