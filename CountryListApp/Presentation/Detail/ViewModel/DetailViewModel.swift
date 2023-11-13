//
//  DetailViewModel.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

final class DetailViewModel {
    typealias Observer<T> = (T) -> Void

    private let detailLoader: DetailLoader

    init(detailLoader: DetailLoader) {
        self.detailLoader = detailLoader
    }

    var title: String {
        Localized.Detail.title
    }

    var onLoadingStateChange: Observer<Bool>?
    var onDetailLoad: Observer<[DetailItem]>?
    var onErrorStateChange: Observer<String?>?

    func loadDetail() {
        onLoadingStateChange?(true)
        onErrorStateChange?(nil)
        detailLoader.load { [weak self] result in
            self?.handle(result)
        }
    }

    private func handle(_ result: DetailLoader.Result) {
        defer { onLoadingStateChange?(false)}
        switch result {
        case .success(let detail):
            onDetailLoad?(detail)
        case .failure:
            onErrorStateChange?(Localized.Detail.loadError)
        }
    }
}
