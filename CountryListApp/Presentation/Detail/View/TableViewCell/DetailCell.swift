//
//  DetailCell.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import UIKit

final class DetailCell: UITableViewCell {
    @IBOutlet private(set) public var commonName: UILabel!
    @IBOutlet private(set) public var shortDetails: UILabel!
    @IBOutlet private(set) public var detailImageContainer: UIView!
    @IBOutlet private(set) public var detailImageView: UIImageView!
    @IBOutlet private(set) public var detailImageRetryButton: UIButton!
    @IBOutlet private(set) public var located: UILabel!
    @IBOutlet private(set) public var timezones: UILabel!

    var onRetry: (() -> Void)?

    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}
