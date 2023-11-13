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
    }
    
    func test_loadingCountryListIndicator_isVisibleWhileLoadingCountryList() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeCountryListLoadingWithError(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        let image0 = makeImage(
            commonName: "a name",
            officialName: "a name",
            region: "a region",
            subregion: "a subregion",
            png: URL(string: "http://another-url.com")!,
            svg: URL(string: "http://another-url.com")!,
            capital: ["a capital"]
        )
        let image1 = makeImage(
            commonName: "a name",
            officialName: nil,
            region: "a region",
            subregion: "a subregion",
            png: URL(string: "http://another-url.com")!,
            svg: URL(string: "http://another-url.com")!,
            capital: ["a capital"]
        )
        let image2 = makeImage(
            commonName: "a name",
            officialName: nil,
            region: "a region",
            subregion: "a subregion",
            png: URL(string: "http://another-url.com")!,
            svg: URL(string: "http://another-url.com")!,
            capital: []
        )

        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeCountryListLoading(with: [image0, image1, image2], at: 0)
        assertThat(sut, isRendering: [image0, image1, image2])
    }

    func test_errorView_showErrorMessage() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeCountryListLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, localized("COUNTRY_LIST_CONNECTION_ERROR"))
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CountryListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CountryListUIComposer.countryComposedWith(countryLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func makeImage(
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
    ) -> CountryListItem {
        return CountryListItem(
            name: CountryListItem.Name(common: commonName, official: officialName),
            region: region,
            subregion: subregion,
            flags: CountryListItem.flagsImage(png: png, svg: svg),
            capital: capital,
            timezones: timezones,
            continents: continents
        )
    }
}
