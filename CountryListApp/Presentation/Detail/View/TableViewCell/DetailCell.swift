//
//  DetailCell.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import UIKit

final class DetailCell: UITableViewCell {
    @IBOutlet private(set) public var nameLabel: UILabel!

    @IBOutlet private(set) public var flagImageContainer: UIView!
    @IBOutlet private(set) public var flagImageView: UIImageView!
    @IBOutlet private(set) public var flagImageRetryButton: UIButton!

    @IBOutlet private(set) public var flagLabel: UILabel!

    @IBOutlet private(set) public var independentImageView: UIImageView!
    @IBOutlet private(set) public var independentLabel: UILabel!

    @IBOutlet private(set) public var unMemberImageView: UIImageView!
    @IBOutlet private(set) public var unMemberLabel: UILabel!

    @IBOutlet private(set) public var statusImageView: UIImageView!
    @IBOutlet private(set) public var statusLabel: UILabel!

    @IBOutlet private(set) public var shieldImageContainer: UIView!
    @IBOutlet private(set) public var shieldImageView: UIImageView!
    @IBOutlet private(set) public var shieldImageRetryButton: UIButton!

    var onFlagRetry: (() -> Void)?
    var onShieldRetry: (() -> Void)?

    @IBAction private func retryFlagButtonTapped() {
        onFlagRetry?()
    }

    @IBAction private func retryShieldButtonTapped() {
        onShieldRetry?()
    }
}
