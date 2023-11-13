//
//  LoaderView.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

final class LoaderView {
    var alert: UIAlertController
    var isLoading: Bool
    
    init() {
        self.alert = UIAlertController(title: nil, message: "Loading", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.style = .large
        alert.view.addSubview(indicator)
        isLoading = false
    }
    
    func beginToLoading(in viewController: UIViewController?) {
        isLoading = true
        viewController?.present(alert, animated: true)
    }
    
    func endToLoading() {
        isLoading = false
        alert.dismiss(animated: true)
    }
}
