//
//  LoadDetailFromRemoteUseCaseTests.swift
//  CountryListAppTests
//
//  Created by Christian Calixto on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class LoadDetailFromRemoteUseCaseTests: XCTestCase {

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

        let item1 = makeItem(commonName: "a name")

        let item2 = makeItem(commonName: "name", officialName: "official name")

        let items = [item1.model, item2.model]

        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])

            client.complete(withStatusCode: 200, data: json)
        }
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteDetailLoader? = RemoteDetailLoader(url: url, client: client)

        var capturedResults = [RemoteDetailLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteDetailLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteDetailLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    private func failure(_ error: RemoteDetailLoader.Error) -> RemoteDetailLoader.Result {
        return .failure(error)
    }

    private func makeItem(
        commonName: String,
        officialName: String = "no showed string",
        independent: Bool = false,
        status: String = "Status",
        unMember: Bool = false,
        capital: [String] = [],
        region: String = "region",
        subregion: String = "subregion",
        timezones: [String] = [],
        continents: [String] = [],
        pngFlag: URL = URL(string: "http:a-url.com")!,
        svgFlag: URL = URL(string: "http:a-url.com")!,
        altFalg: String = "short description",
        startOfWeek: String = "monday"
    ) -> (model: DetailItem, json: [String: Any]) {

        let item = DetailItem(
            name: DetailItem.Name(
                common: commonName,
                official: officialName
            ),
            independent: independent,
            status: status,
            unMember: unMember,
            capital: capital,
            region: region,
            subregion: subregion,
            maps: DetailItem.Maps(
                googleMaps: anyURL().absoluteString,
                openStreetMaps: anyURL().absoluteString
            ),
            timezones: timezones,
            continents: continents,
            flags: DetailItem.Flags(
                png: pngFlag,
                svg: svgFlag,
                alt: altFalg),
            startOfWeek: startOfWeek, 
            coatOfArms: nil
        )

        let json = [
            "name": [
                "common" : commonName,
                "official" : officialName
            ],
            "independent": independent,
            "status": status,
            "unMember": unMember,
            "capital": capital,
            "region": region,
            "subRegion": subregion,
            "maps": [
                "googleMaps": anyURL().absoluteString,
                "openStreetMaps": anyURL().absoluteString
            ],
            "timezones": timezones,
            "continents": continents,
            "flags": [
                "png": pngFlag.absoluteString,
                "svg": svgFlag.absoluteString,
                "alt": altFalg
            ],
            "startOfWeek": startOfWeek
        ].compactMapValues{ $0 }

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = items
        return try! JSONSerialization.data(withJSONObject: json)
    }

    private func expect(_ sut: RemoteDetailLoader, toCompleteWith expectedResult: RemoteDetailLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {

        let exp = expectation(description: "Wait for load")

        sut.load { receivedResult in
            switch ( receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as RemoteDetailLoader.Error), .failure(expectedError as RemoteDetailLoader.Error)):
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

