//
//  CountryListUIComposer.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

final class CountryListUIComposer {
    private init() {}
    
    public static func countryComposedWith(
        countryLoader: CountryLoader,
        imageLoader: ImageDataLoader,
        selection: @escaping (String?) -> Void = { _ in }
    ) -> CountryListViewController {
        let countryViewModel = CountryListViewModel(countryLoader: MainQueueDispatchDecorator(decorate: countryLoader))
        let countryController = CountryListViewController.makeWith(viewModel: countryViewModel)
        
        countryViewModel.onCountryLoad = adaptCountryToCellController(
            forwardingTo: countryController,
            imageLoader: MainQueueDispatchDecorator(decorate: imageLoader),
            selection: selection
        )
        return countryController
    }
    
    private static func adaptCountryToCellController(
        forwardingTo controller: CountryListViewController,
        imageLoader: ImageDataLoader,
        selection: @escaping (String?) -> Void
    ) -> ([CountryListItem]) -> Void {
        return { [weak controller] country in
            controller?.tableModel = country.map { model in
                CountryCellController(
                    viewModel: CountryCellViewModel(
                        model: model,
                        imageLoader: imageLoader,
                        imageTransformer: UIImage.init
                    ),
                    selection: { [selection] in
                        selection(model.name?.common)
                    }
                )
            }
        }
    }
}

private extension CountryListViewController {
    static func makeWith(viewModel: CountryListViewModel) -> CountryListViewController {
        let bundle = Bundle(for: CountryListViewController.self)
        let storyboard = UIStoryboard(name: "Country", bundle: bundle)
        let countryController = storyboard.instantiateInitialViewController() as! CountryListViewController
        countryController.viewModel = viewModel
        return countryController
    }
}
