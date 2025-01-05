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
        let condition = HTTPClientTypeProvider.Condition.prod
        HTTPClientTypeProviderStub.stubbedConditionRepresentable = condition
        let url = anyURL()
        
        let (sut, prodClient, stubbedClient) = makeSUT(clientTypeCondition: condition)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(prodClient.requestedURLs, [url])
        XCTAssertEqual(stubbedClient.requestedURLs, [])
    }
    
    func testStubbedTypeUsesStubbedClient() {
        let condition = HTTPClientTypeProvider.Condition.stubbed
        HTTPClientTypeProviderStub.stubbedConditionRepresentable = condition
        let url = anyURL()
        
        let (sut, prodClient, stubbedClient) = makeSUT(clientTypeCondition: condition)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(stubbedClient.requestedURLs, [url])
        XCTAssertEqual(prodClient.requestedURLs, [])
    }
    
    func testNoMatchingTypeUsesProdClient() {
        let condition = HTTPClientTypeProviderStub.Default.condition
        HTTPClientTypeProviderStub.stubbedConditionRepresentable = condition
        let url = anyURL()
        
        let (sut, prodClient, stubbedClient) = makeSUT(clientTypeCondition: condition)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(prodClient.requestedURLs, [url])
        XCTAssertEqual(stubbedClient.requestedURLs, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(clientTypeCondition: any ConditionRepresentable, file: StaticString = #file, line: UInt = #line) -> (sut: HTTPClientWithStubbedComposite, prodClient: HTTPClientSpy, stubbedClient: HTTPClientSpy) {
        let prodClient = HTTPClientSpy()
        let stubbedClient = HTTPClientSpy()
        let clientTypeProvider = HTTPClientTypeProviderStub()
        let sut = HTTPClientWithStubbedComposite(prod: prodClient, stubbed: stubbedClient, typeProvider: clientTypeProvider)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(prodClient, file: file, line: line)
        trackForMemoryLeaks(stubbedClient, file: file, line: line)
        trackForMemoryLeaks(clientTypeProvider, file: file, line: line)
        return (sut, prodClient, stubbedClient)
    }
    
    private final class HTTPClientTypeProviderStub: TypeProviding {
        enum Default: ConditionRepresentable {
            case condition
        }
        
        static var stubbedConditionRepresentable: (any ConditionRepresentable) = HTTPClientTypeProviderStub.Default.condition
        
        var current: any ConditionRepresentable {
            HTTPClientTypeProviderStub.stubbedConditionRepresentable
        }
    }
}
