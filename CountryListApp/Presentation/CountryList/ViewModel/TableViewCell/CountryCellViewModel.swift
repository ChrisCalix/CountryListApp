//
//  CountryCellViewModel.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

final class CountryCellViewModel<Image> {
    typealias Observer<T> = (T) -> Void
    private var task: ImageDataLoaderTask?
    private let model: CountryListItem
    private let imageLoader: ImageDataLoader
    private let imageTransformer: (Data) -> Image?
    private var image: Image?
    
    init(model: CountryListItem, imageLoader: ImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
        image = nil
    }
    
    var commonName: String? {
        return model.name?.common
    }
    
    var timezone: String? {
        guard let timezones = model.timezones?.joined(separator: " and ") else  {
            return nil
        }
        return "Timezones: " + timezones
    }
    
    var located: String {
        var located = String()
        if let continents = model.continents?.joined(separator: " and ") {
            located.append("Located in ")
            located.append(continents)
            located.append(". ")
        }
        if let region = model.region, let subRegion = model.subregion {
            located.append("Region ")
            located.append(region)
            located.append(" and Subregion ")
            located.append("\(subRegion).")
        }
        return located
    }
    
    var details: String {
        var details = String()
        if let officialName = model.name?.official {
            details.append("Official name is ")
            details.append(officialName)
            details.append(". ")
        }
        if let capitals = model.capital {
            details.append("The capital")
            details.append(capitals.count > 1 ? "s are " : " is ")
            details.append(capitals.joined(separator: " and "))
        }
        return details
    }
    
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    func loadImageData() {
        onShouldRetryImageLoadStateChange?(false)
        if let image = image {
            self.onImageLoad?(image)
        } else {
            onImageLoadingStateChange?(true)
            task = imageLoader.loadImageData(from: model.flags.png){ [weak self] result in
                self?.handle(result)
            }
        }
    }
    
    private func handle(_ result: ImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            self.image = image
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
