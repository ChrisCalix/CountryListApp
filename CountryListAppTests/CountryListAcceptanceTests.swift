//
//  CountryListAcceptanceTests.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import XCTest
@testable import CountryListApp

final class CountryListAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteCountryWhenCustomerHasConnectivity() {

        let countryList = launch(httpClient: .online(response))
        
        XCTAssertEqual(countryList.numberOfRenderedCountryImageViews(), 2)
        XCTAssertEqual(countryList.renderedCountryImageData(at: 0), makeImageData())
        XCTAssertEqual(countryList.renderedCountryImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysCachedRemoteCountryWhenCustomerHasNoConnectivity() {
        let onlineCountryList = launch(httpClient: .online(response))
        onlineCountryList.simulateCountryImageViewVisible(at: 0)
        onlineCountryList.simulateCountryImageViewVisible(at: 1)
        
        let offlineCountryList = launch(httpClient: .offline)
        
        XCTAssertEqual(offlineCountryList.numberOfRenderedCountryImageViews(), 0)
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
            return makeCountryData()
        }
    }
    
    private func makeImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
    
    private func makeCountryData() -> Data {
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
