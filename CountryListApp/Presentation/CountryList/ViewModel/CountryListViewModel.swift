//
//  CountryListViewModel.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

final class CountryListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let countryLoader: CountryLoader
    
    init(countryLoader: CountryLoader) {
        self.countryLoader = countryLoader
    }
    
    var title: String {
        Localized.CountryList.title
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onCountryLoad: Observer<[CountryListItem]>?
    var onErrorStateChange: Observer<String?>?
    
    func loadCountry() {
        onLoadingStateChange?(true)
        onErrorStateChange?(nil)
        countryLoader.load { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: CountryLoader.Result) {
        defer { onLoadingStateChange?(false)}
        switch result {
        case .success(let country):
            onCountryLoad?(country)
        case .failure:
            onErrorStateChange?(Localized.CountryList.loadError)
        }
    }
}
