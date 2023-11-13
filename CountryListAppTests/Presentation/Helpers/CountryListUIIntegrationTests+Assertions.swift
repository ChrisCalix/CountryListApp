//
//  CountryListUIIntegrationTests+Assertions.swift
//  CountryListAppTests
//
//  Created by Christian Calixto on 13/11/23.
//

import XCTest
@testable import CountryListApp

extension CountryListUIIntegrationTests {
    func assertThat(_ sut: CountryListViewController, isRendering countryList: [CountryListItem], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedCountryImageViews() == countryList.count else {
            return XCTFail("Expected \(countryList.count) images, got \(sut.numberOfRenderedCountryImageViews()) instead.", file: file, line: line)
        }

        countryList.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: CountryListViewController, hasViewConfiguredFor image: CountryListItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.countryImageView(at: index)

        guard let cell = view as? CountryCell else {
            return XCTFail("Expected \(CountryCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertFalse(cell.locationText?.isEmpty ?? true, "Expected location text to be not empty for image  view at index (\(index))", file: file, line: line)

        XCTAssertFalse(cell.descriptionText?.isEmpty ?? true, "Expected description text to be not empty for image  view at index (\(index))", file: file, line: line)
    }
}
