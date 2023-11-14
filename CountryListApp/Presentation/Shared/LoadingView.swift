//
//  LoaderView.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit
protocol Loading {
    var isLoading: Bool { get }

    func beginToLoading(in viewController: UIViewController?)
    func endToLoading()
}

final class LoadingView: Loading {
    var isLoading: Bool
    var alert: UIAlertController
    
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

        self.alert.dismiss(animated: true)
    }
}
