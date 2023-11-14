//
//  UIImage+SystemSymbols.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import UIKit

extension UIImage {
    static func makeCheckMark() -> UIImage? {
        UIImage(systemName: "checkmark")
    }

    static func makeXMark() -> UIImage? {
        UIImage(systemName: "xmark")
    }
}
