//
//  CountryListUIIntegrationTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class CountryListUIIntegrationTests: XCTestCase {
    
    func test_countryListView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, localized("COUNTRY_LIST_VIEW_TITLE"))
    }
    
    func test_loadCountryListActions_requestCountryListFromLoader() {
        let (sut, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCountryListCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCountryListCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCountryListCallCount, 2, "Expected another loading request once user initiates a reload")

        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCountryListCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CountryListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CountryListUIComposer.countryComposedWith(countryLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}
