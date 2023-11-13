//
//  LoadCountryListFromRemoteUseCaseTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class LoadCountryListFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let expectedResult: RemoteCountryLoader.Result = failure(.connectivity)
        let exp = expectation(description: "Wait for load")
        
        sut.load { receivedResult in
            switch ( receivedResult, expectedResult) {
            
            case let (.failure(receivedError as RemoteCountryLoader.Error), .failure(expectedError as RemoteCountryLoader.Error)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected result \(expectedResult) instead")
            }
            exp.fulfill()
        }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            let expectedResult: RemoteCountryLoader.Result = failure(.invalidData)
            let exp = expectation(description: "Wait for load")
            
            sut.load { receivedResult in
                switch ( receivedResult, expectedResult) {
                
                case let (.failure(receivedError as RemoteCountryLoader.Error), .failure(expectedError as RemoteCountryLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError)
                default:
                    XCTFail("Expected result \(expectedResult) instead")
                }
                exp.fulfill()
            }
            
            let json = makeItemsJSON([])
            client.complete(withStatusCode: code, data: json, at: index)
            
            wait(for: [exp], timeout: 1.0)
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        let expectedResult: RemoteCountryLoader.Result = failure(.invalidData)
        let exp = expectation(description: "Wait for load")
        
        sut.load { receivedResult in
            switch ( receivedResult, expectedResult) {
            
            case let (.failure(receivedError as RemoteCountryLoader.Error), .failure(expectedError as RemoteCountryLoader.Error)):
                XCTAssertEqual(receivedError, expectedError)
            default:
                XCTFail("Expected result \(expectedResult) instead")
            }
            exp.fulfill()
        }
        
        let invalidJSON = Data("invalid json".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteCountryLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteCountryLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteCountryLoader.Error) -> RemoteCountryLoader.Result {
        return .failure(error)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = items
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
