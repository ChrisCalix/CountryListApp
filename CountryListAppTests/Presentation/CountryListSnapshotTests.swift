//
//  CountryListSnapshotTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class CountryListSnapshotTests: XCTestCase {
    
    func test_emptyCountryList() {
        let sut = makeSUT()

        sut.display(emptyFeed())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_COUNTRY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_COUNTRY_LIST_dark")
    }

    func test_countryListWithError() {
        let sut = makeSUT()

        sut.display(errorMessage: "An error message")

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "COUNTRY_LIST_WITH_ERROR_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "COUNTRY_LIST_WITH_ERROR_dark")
    }
    
    func test_CountryListWithContent() {
        let sut = makeSUT()
        
        sut.display(countryListWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "COUNTRY_LIST_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "COUNTRY_LIST_WITH_CONTENT_dark")
    }

    // MARK: - Helpers

    private func makeSUT() -> CountryListViewController {
        let client = HTTPClientSpy()
        let imageLoader = RemoteImageDataLoader(client: client)
        let controller = CountryListUIComposer.countryComposedWith(countryLoader: AlwaysSucceedingFeedLoader(), imageLoader: imageLoader)
       
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func emptyFeed() -> [CountryCellController] {
        []
    }
    
    private func countryListWithContent() -> [CountryStub] {
        let client = HTTPClientSpy()
        let imageLoader = RemoteImageDataLoader(client: client)
        return [
            CountryStub(
                commonName: "a name",
                officialName: "a name",
                region: "a region",
                subregion: "a subregion",
                png: URL(string: "http://another-url.com")!,
                svg: URL(string: "http://another-url.com")!,
                capital: ["a capital"],
                imageLoader: imageLoader
            ),
            CountryStub(
                commonName: "a name",
                officialName: "a name",
                region: "a region",
                subregion: "a subregion",
                timezones: ["hour"],
                png: URL(string: "http://another-url.com")!,
                svg: URL(string: "http://another-url.com")!,
                flagURL: URL(string: "http://another-url.com")!,
                continents: ["continent"],
                capital: ["a capital"],
                imageLoader: imageLoader
            ),
        ]
    }
}

private class AlwaysSucceedingFeedLoader: CountryLoader {
    func load(completion: @escaping (CountryLoader.Result) -> Void) {
        completion(.success([]))
    }
}

private extension CountryListViewController {
    func display(errorMessage: String) {
        errorView?.showAnimated(errorMessage)
    }

    func display(_ feed: [CountryCellController]) {
        tableModel = feed
    }
}

private extension CountryListViewController {
    func display(_ stubs: [CountryStub]) {
        let cells: [CountryCellController] = stubs.map { stub in
            let cellController = CountryCellController(viewModel: stub.viewModel, selection: {})
            stub.controller = cellController
            return cellController
        }
        
        display(cells)
    }
}

private final class CountryStub {
    let viewModel: CountryCellViewModel<UIImage>
    weak var controller: CountryCellController?
    
    init(
        commonName: String,
        officialName: String? = nil,
        region: String,
        subregion: String,
        timezones: [String] = [],
        png: URL = anyURL(),
        svg: URL = anyURL(),
        flagURL: URL = anyURL(),
        continents: [String] = [],
        capital: [String],
        imageLoader: ImageDataLoader
    ) {
        self.viewModel = CountryCellViewModel(
            model: makeItem(
                commonName: commonName,
                officialName: officialName,
                region: region,
                subregion: subregion,
                timezones: timezones,
                png: png,
                svg: svg,
                flagURL: flagURL,
                continents: continents,
                capital: capital
            ),
            imageLoader: imageLoader,
            imageTransformer: { _ in return UIImage.init() }
        )
    }
    
    func didRequestImage() {
        controller?.display(viewModel)
    }
    
    func didCancelImageRequest() { }
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
) -> CountryListItem {
    CountryListItem(
        name: CountryListItem.Name(common: commonName, official: officialName),
        region: region,
        subregion: subregion,
        flags: CountryListItem.flagsImage(png: png, svg: svg),
        capital: capital,
        timezones: timezones,
        continents: continents
    )
}
