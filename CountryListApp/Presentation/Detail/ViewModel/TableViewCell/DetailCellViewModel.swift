//
//  DetailCellViewModel.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

final class DetailCellViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    private var flagTask: ImageDataLoaderTask?
    private var shieldTask: ImageDataLoaderTask?
    private let model: DetailItem
    private let imageLoader: ImageDataLoader
    private let imageTransformer: (Data) -> Image?
    private var flagImage: Image?
    private var shieldImage: Image?

    var commonName: String? {
        return model.name?.common
    }

    var onFlagImageLoad: Observer<Image>?
    var onFlagImageLoadingStateChange: Observer<Bool>?
    var onFlagShouldRetryImageLoadStateChange: Observer<Bool>?

    var onShieldImageLoad: Observer<Image>?
    var onShieldImageLoadingStateChange: Observer<Bool>?
    var onShieldShouldRetryImageLoadStateChange: Observer<Bool>?

    init(model: DetailItem, imageLoader: ImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
        flagImage = nil
        shieldImage = nil
    }

    var name: String? {
        return model.name?.common
    }

    var altFlag: String? {
        return model.flags?.alt
    }

    var status: Bool {
        return model.status?.isEmpty ?? false
    }

    var independent: Bool {
        model.independent ?? false
    }

    var unMember: Bool {
        model.unMember ?? false
    }

    func loadFlagImageData() {
        guard let flag = model.flags?.png else { return }
        onFlagShouldRetryImageLoadStateChange?(false)
        if let flagImage = flagImage {
            self.onFlagImageLoad?(flagImage)
        } else {
            onFlagImageLoadingStateChange?(true)
            flagTask = imageLoader.loadImageData(from: flag){ [weak self] result in
                self?.handleFlag(result)
            }
        }
    }

    private func handleFlag(_ result: ImageDataLoader.Result) {
        if let flagImage = (try? result.get()).flatMap(imageTransformer) {
            self.flagImage = flagImage
            onFlagImageLoad?(flagImage)
        } else {
            onFlagShouldRetryImageLoadStateChange?(true)
        }
        onFlagImageLoadingStateChange?(false)
    }

    func loadShieldImageData() {
        guard let coatOfArms = model.coatOfArms?.png else {
            return
        }
        onShieldShouldRetryImageLoadStateChange?(false)
        if let shieldImage = shieldImage {
            self.onShieldImageLoad?(shieldImage)
        } else {
            onShieldImageLoadingStateChange?(true)
            shieldTask = imageLoader.loadImageData(from: coatOfArms){ [weak self] result in
                self?.handleShield(result)
            }
        }
    }

    private func handleShield(_ result: ImageDataLoader.Result) {
        if let shieldImage = (try? result.get()).flatMap(imageTransformer) {
            self.shieldImage = shieldImage
            onShieldImageLoad?(shieldImage)
        } else {
            onShieldShouldRetryImageLoadStateChange?(true)
        }
        onShieldImageLoadingStateChange?(false)
    }

    func cancelImageDataLoad() {
        flagTask?.cancel()
        flagTask = nil
        shieldTask?.cancel()
        shieldTask = nil
    }
}
