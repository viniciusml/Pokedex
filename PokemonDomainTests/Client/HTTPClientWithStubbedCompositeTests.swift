//
//  HTTPClientWithStubbedCompositeTests.swift
//  PokemonDomainTests
//
//  Created by Vinicius Leal on 14/01/2023.
//  Copyright © 2023 Vinicius Moreira Leal. All rights reserved.
//

import PokemonDomain
import XCTest

final class HTTPClientWithStubbedCompositeTests: XCTestCase {
    
    func testProdTypeUsesProdClient() {
        let url = anyURL()
        
        let (sut, prodClient, stubbedClient) = makeSUT(clientType: .prod)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(prodClient.requestedURLs, [url])
        XCTAssertEqual(stubbedClient.requestedURLs, [])
    }
    
    func testStubbedTypeUsesStubbedClient() {
        let url = anyURL()
        
        let (sut, prodClient, stubbedClient) = makeSUT(clientType: .stubbed)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(stubbedClient.requestedURLs, [url])
        XCTAssertEqual(prodClient.requestedURLs, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(clientType: HTTPClientType.ClientType, file: StaticString = #file, line: UInt = #line) -> (sut: HTTPClientWithStubbedComposite, prodClient: HTTPClientSpy, stubbedClient: HTTPClientSpy) {
        let prodClient = HTTPClientSpy()
        let stubbedClient = HTTPClientSpy()
        let sut = HTTPClientWithStubbedComposite(prod: prodClient, stubbed: stubbedClient, clientType: clientType)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(prodClient, file: file, line: line)
        trackForMemoryLeaks(stubbedClient, file: file, line: line)
        return (sut, prodClient, stubbedClient)
    }
}
