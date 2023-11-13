//
//  UIControl+TestHelpers.swift
//  CountryListAppTests
//
//  Created by Sonic on 13/11/23.
//

import Foundation

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
