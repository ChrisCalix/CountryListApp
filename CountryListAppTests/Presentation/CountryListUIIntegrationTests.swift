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

    func test_loadCountryListCompletion_rendersSuccessfullyLoadedCountryList() {
        let image0 = makeImage(officialName: "a name", capital: ["a capital"])
        let image1 = makeImage(officialName: nil, capital: ["a capital"])
        let image2 = makeImage(officialName: nil, capital: [])

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

    func test_countryImageView_loadsImageURLWhenVisible() {
        let image0 = makeImage(officialName: "a name", imageUrl: URL(string: "http://url-0.com")!, capital: ["a capital"])
        let image1 = makeImage(officialName: "a name", imageUrl: URL(string: "http://url-1.com")!, capital: ["a capital"])
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [image0, image1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateCountryImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png], "Expected first image URL request once first view becomes visible")

        sut.simulateCountryImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png, image1.flags.png], "Expected second image URL request once second view also becomes visible")
    }
    
    func test_countryImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let image0 = makeImage(officialName: "a name", imageUrl: URL(string: "http://url-0.com")!, capital: ["a capital"])
        let image1 = makeImage(officialName: "a name", imageUrl: URL(string: "http://url-1.com")!, capital: ["a capital"])
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [image0, image1])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")

        sut.simulateCountryImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.flags.png], "Expected one cancelled image URL request once first image is not visible anymore")

        sut.simulateCountryImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.flags.png, image1.flags.png], "Expected two cancelled image URL requests once second image is also not visible anymore")
    }
    
    func test_countryImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [makeImage(), makeImage()])

        let view0 = sut.simulateCountryImageViewVisible(at: 0)
        let view1 = sut.simulateCountryImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")

        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
    }
    
    func test_countryImageView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [makeImage(), makeImage()])

        let view0 = sut.simulateCountryImageViewVisible(at: 0)
        let view1 = sut.simulateCountryImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
    }

    func test_countryImageViewRetryButton_isVisibleOnImageURLLoadError() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [makeImage(), makeImage()])

        let view0 = sut.simulateCountryImageViewVisible(at: 0)
        let view1 = sut.simulateCountryImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")

        let imageData = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData, at: 0)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")

        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")
    }
    
    func test_countryImageViewRetryButton_isVisibleOnInvalidImageData() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [makeImage()])

        let view = sut.simulateCountryImageViewVisible(at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")

        let invalidImageData = Data("invalid image data".utf8)
        loader.completeImageLoading(with: invalidImageData, at: 0)
        XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
    }

    func test_countryImageViewRetryAction_retriesImageLoad() {
        let image0 = makeImage(imageUrl: URL(string: "http://url-0.com")!)
        let image1 = makeImage(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [image0, image1])

        let view0 = sut.simulateCountryImageViewVisible(at: 0)
        let view1 = sut.simulateCountryImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png, image1.flags.png], "Expected two image URL request for the two visible views")

        loader.completeImageLoadingWithError(at: 0)
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png, image1.flags.png], "Expected only two image URL requests before retry action")

        view0?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png, image1.flags.png, image0.flags.png], "Expected third imageURL request after first view retry action")

        view1?.simulateRetryAction()
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png, image1.flags.png, image0.flags.png, image1.flags.png], "Expected fourth imageURL request after second view retry action")
    }

    func test_countryImageView_preloadsImageURLWhenNearVisible() {
        let image0 = makeImage(imageUrl: URL(string: "http://url-0.com")!)
        let image1 = makeImage(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [image0, image1])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")

        sut.simulateCountryImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png], "Expected first image URL request once first image is near visible")

        sut.simulateCountryImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.flags.png, image1.flags.png], "Expected second image URL request once second image is near visible")
    }

    func test_countryImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
        let image0 = makeImage(imageUrl: URL(string: "http://url-0.com")!)
        let image1 = makeImage(imageUrl: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [image0, image1])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")

        sut.simulateCountryImageViewNotNearVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.flags.png], "Expected first cancelled image URL request once first image is not near visible anymore")

        sut.simulateCountryImageViewNotNearVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.flags.png, image1.flags.png], "Expected second cancelled image URL request once second image is not near visible anymore")
    }

    func test_countryImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [makeImage()])

        let view = sut.simulateCountryImageViewNotVisible(at: 0)
        loader.completeImageLoading(with: anyImageData())

        XCTAssertNil(view?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    }

    func test_loadCountryListCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeCountryListLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeCountryListLoading(with: [makeImage()])
        _ = sut.simulateCountryImageViewVisible(at: 0)

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: self.anyImageData(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: CountryListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CountryListUIComposer.countryComposedWith(
            countryLoader: loader,
            imageLoader: loader,
            loadingView: LoadingView()
        )
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

    private func makeImage(
        officialName: String? = nil,
        imageUrl: URL = URL(string: "http://another-url.com")!,
        capital: [String] = []
    ) -> CountryListItem {
        return CountryListItem(
            name: CountryListItem.Name(common: "a name", official: officialName),
            region: "a region",
            subregion: "a subregion",
            flags: CountryListItem.flagsImage(
                png: imageUrl,
                svg: imageUrl
            ),
            capital: capital,
            timezones: [],
            continents: []
        )
    }
    
    private func anyImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
}
