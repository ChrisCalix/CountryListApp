//
//  LoadImageDataFromRemoteUseCaseTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class LoadImageDataFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotPerformAnyUrlRequest() {
        let client = HTTPClientSpy()
        
        trackForMemoryLeaks(client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
