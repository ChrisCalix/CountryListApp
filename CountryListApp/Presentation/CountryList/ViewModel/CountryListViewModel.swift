//
//  CountryListViewModel.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

final class CountryListViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let countryLoader: CountryListLoader
    private var items: [CountryListItem]

    init(countryLoader: CountryListLoader) {
        self.countryLoader = countryLoader
        items = []
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
    
    private func handle(_ result: CountryListLoader.Result) {
        defer { onLoadingStateChange?(false)}
        switch result {
        case .success(let country):
            items = country
            onCountryLoad?(country)
        case .failure:
            onErrorStateChange?(Localized.CountryList.loadError)
        }
    }

    func filter(by text: String) {
        guard !text.isEmpty else {
            return
        }
        let countryFiltered = items.filter { countryItem in
            countryItem.name.common.contains(text)
        }
        onCountryLoad?(countryFiltered)
    }
}
