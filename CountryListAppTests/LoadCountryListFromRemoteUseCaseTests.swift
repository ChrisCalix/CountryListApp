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
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(
            commonName: "a name",
            officialName: "a name",
            region: "a region",
            subregion: "a subregion",
            png: URL(string: "http://another-url.com")!,
            svg: URL(string: "http://another-url.com")!,
            capital: ["a capital"]
        )
        
        let item2 = makeItem(
            commonName: "a name",
            officialName: "a name",
            region: "a region",
            subregion: "a subregion",
            timezones: ["hour"],
            png: URL(string: "http://another-url.com")!,
            svg: URL(string: "http://another-url.com")!,
            flagURL: URL(string: "http://another-url.com")!,
            continents: ["continent"],
            capital: ["a capital"]
        )
       
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            
            print("emptyListJSON \(String(decoding: json, as: UTF8.self))")
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteCountryLoader? = RemoteCountryLoader(url: url, client: client)
        
        var capturedResults = [RemoteCountryLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
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
    
    private func makeItem(
        commonName: String,
        officialName: String? = nil,
        region: String,
        subregion: String,
        timezones: [String] = [],
        png: URL = anyURL(),
        svg: URL = anyURL(),
        flagURL: URL = anyURL(),
        continents: [String] = [],
        capital: [String]
    ) -> (model: CountryListItem, json: [String: Any]) {
        let item = CountryListItem(
            name: CountryListItem.Name(common: commonName, official: officialName),
            region: region,
            subregion: subregion,
            flags: CountryListItem.flagsImage(png: png, svg: svg),
            capital: capital,
            timezones: timezones,
            continents: continents
        )
        
        let json = [
            "name": [
                "common" : commonName,
                "official" : officialName
            ],
            "region": region,
            "subRegion": subregion,
            "flags": [
                "png": png.absoluteString,
                "svg": svg.absoluteString
            ],
            "capital": capital,
            "timezones": timezones,
            "continents": continents
        ].compactMapValues{ $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = items
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteCountryLoader, toCompleteWith expectedResult: RemoteCountryLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load")
        
        sut.load { receivedResult in
            switch ( receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteCountryLoader.Error), .failure(expectedError as RemoteCountryLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
