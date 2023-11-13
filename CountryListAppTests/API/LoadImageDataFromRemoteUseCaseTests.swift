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
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let url = URL(string: "https://a-given0url.com")!
        let (sut, client) = makeSUT(url: url)
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = anyURL(), file: StaticString = #file, line: UInt = #line) -> (sut: RemoteImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteImageDataLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
}
