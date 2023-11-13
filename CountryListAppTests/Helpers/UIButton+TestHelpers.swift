//
//  UIButton+TestHelpers.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}

