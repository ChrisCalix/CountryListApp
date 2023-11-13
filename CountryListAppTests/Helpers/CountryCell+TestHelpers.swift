//
//  CountryCell+TestHelpers.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import UIKit
@testable import CountryListApp

extension CountryCell {
    func simulateRetryAction() {
        countryImageRetryButton.simulateTap()
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return countryImageContainer.isShimmering
    }
    
    var isShowingRetryAction: Bool {
        return !countryImageRetryButton.isHidden
    }
    
    var locationText: String? {
        return located.text
    }
    
    var descriptionText: String? {
        return timezones.text
    }
    
    var renderedImage: Data? {
        return countryImageView.image?.pngData()
    }
}
