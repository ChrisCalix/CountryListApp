//
//  CountryCell.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

public final class CountryCell: UITableViewCell {
    @IBOutlet private(set) public var commonName: UILabel!
    @IBOutlet private(set) public var shortDetails: UILabel!
    @IBOutlet private(set) public var countryImageContainer: UIView!
    @IBOutlet private(set) public var countryImageView: UIImageView!
    @IBOutlet private(set) public var countryImageRetryButton: UIButton!
    @IBOutlet private(set) public var located: UILabel!
    @IBOutlet private(set) public var timezones: UILabel!
    
    var onRetry: (() -> Void)?
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
