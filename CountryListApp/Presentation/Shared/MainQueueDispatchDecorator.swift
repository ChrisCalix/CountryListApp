//
//  MainQueueDispatchDecorator.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit
import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decorate: T
    
    init(decorate: T) {
        self.decorate = decorate
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: CountryListLoader where T == CountryListLoader {
    func load(completion: @escaping (CountryListLoader.Result) -> Void) {
        decorate.load { [weak self] result in
            self?.dispatch { completion(result)}
        }
    }
}

extension MainQueueDispatchDecorator: ImageDataLoader where T == ImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        return decorate.loadImageData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: Loading where T == Loading {
    var isLoading: Bool {
        self.decorate.isLoading
    }

    func endToLoading() {
        self.dispatch {
            self.decorate.endToLoading()
        }
    }
    
    func beginToLoading(in viewController: UIViewController?) {
        self.dispatch {
            self.decorate.beginToLoading(in: viewController)
        }
    }
}
