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
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = URL(string: "https://a-given0url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
}
