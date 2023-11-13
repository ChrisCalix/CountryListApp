//
//  CountryListViewController+TestHelpers.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import UIKit
@testable import CountryListApp

extension CountryListViewController {
    
    @discardableResult
    func simulateCountryImageViewVisible(at index: Int) -> CountryCell? {
        return countryImageView(at: index) as? CountryCell
    }
    
    @discardableResult
    func simulateCountryImageViewNotVisible(at row: Int) -> CountryCell? {
        let view = simulateCountryImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: countryImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }
    
    func simulateCountryImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: countryImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateCountryImageViewNotNearVisible(at row: Int) {
        simulateCountryImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: countryImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func renderedCountryImageData(at index: Int) -> Data? {
        return simulateCountryImageViewVisible(at: index)?.renderedImage
    }

    var errorMessage: String? {
        return errorView?.message
    }
    
    var isShowingLoadingIndicator: Bool {
        return loader?.isLoading ?? false
    }
    
    func numberOfRenderedCountryImageViews() -> Int {
        return tableView.numberOfRows(inSection: countryImagesSection)
    }
    
    func countryImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedCountryImageViews() > row else { return nil }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: countryImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var countryImagesSection: Int {
        return 0
    }
}

