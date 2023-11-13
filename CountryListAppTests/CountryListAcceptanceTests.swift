//
//  CountryListAcceptanceTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class CountryListAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        
        let countryList = launch(httpClient: .online(response))
        
        XCTAssertEqual(countryList.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(countryList.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(countryList.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let onlineFeed = launch(httpClient: .online(response))
        onlineFeed.simulateCountryImageViewVisible(at: 0)
        onlineFeed.simulateCountryImageViewVisible(at: 1)
        
        let offlineFeed = launch(httpClient: .offline)
        
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 0)
    }
    
    
    private func launch(httpClient: HTTPCLientStub = .offline) -> CountryListViewController {
        let sut = SceneDelegate(httpClient: httpClient)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! CountryListViewController
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
        case "http://image.com":
            return makeImageData()
        default:
            return makeFeedData()
        }
    }
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            [
                "name": [
                    "common" : "common name",
                    "official" : "official name"
                ],
                "flags": [
                    "png": "http://image.com",
                    "svg": "http://image.com"
                ]
            ],
            [
                "name": [
                    "common" : "a common name",
                    "official" : "a official name"
                ],
                "flags": [
                    "png": "http://image.com",
                    "svg": "http://image.com"
                ]
            ]
        ])
    }
}
