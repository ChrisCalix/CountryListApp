//
//  UIImageView+Animations.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        //TODO: check main thread
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
