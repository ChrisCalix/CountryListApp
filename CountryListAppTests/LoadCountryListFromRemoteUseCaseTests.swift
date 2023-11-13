//
//  LoadCountryListFromRemoteUseCaseTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest

final class LoadCountryListFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        
        trackForMemoryLeaks(client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
}
