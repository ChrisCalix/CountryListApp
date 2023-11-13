//
//  CountryListViewController+TestHelpers.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import UIKit
@testable import CountryListApp

extension CountryListViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateCountryImageViewVisible(at index: Int) -> CountryCell? {
        return countryImageView(at: index) as? CountryCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> CountryCell? {
        let view = simulateCountryImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: countryImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: countryImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: countryImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateCountryImageViewVisible(at: index)?.renderedImage
    }
    var errorMessage: String? {
        return errorView?.message
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        return tableView.numberOfRows(inSection: countryImagesSection)
    }
    
    func countryImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedImageViews() > row else { return nil }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: countryImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var countryImagesSection: Int {
        return 0
    }
}

