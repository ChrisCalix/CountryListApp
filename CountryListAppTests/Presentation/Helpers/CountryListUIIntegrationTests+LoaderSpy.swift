//
//  CountryListUIIntegrationTests+LoaderSpy.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

extension CountryListUIIntegrationTests {
    class LoaderSpy: CountryLoader, ImageDataLoader {
        // MARK: - CountryLoader

        private var countryListRequests = [(CountryLoader.Result) -> Void]()

        var loadCountryListCallCount: Int {
            return countryListRequests.count
        }

        func load(completion: @escaping (CountryLoader.Result) -> Void) {
            countryListRequests.append(completion)
        }

        func completeFeedLoading(with feed: [CountryListItem] = [], at index: Int = 0) {
            countryListRequests[index](.success(feed))
        }

        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            countryListRequests[index](.failure(error))
        }

        // MARK: - FeedImageDataLoader

        private struct TaskSpy: ImageDataLoaderTask {
            let cancelCallback: () -> Void
            func cancel() {
                cancelCallback()
            }
        }

        private var imageRequests = [(url: URL, completion: (ImageDataLoader.Result) -> Void)]()

        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }

        private(set) var cancelledImageURLs = [URL]()

        func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
            imageRequests.append((url, completion))
            return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
        }

        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }

        func completeImageLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            imageRequests[index].completion(.failure(error))
        }
    }
}
