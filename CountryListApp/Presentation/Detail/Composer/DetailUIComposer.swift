//
//  DetailUIComposer.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import UIKit

final class DetailUIComposer {
    private init() {}

    public static func detailComposedWith(
        detailLoader: DetailLoader,
        imageLoader: ImageDataLoader,
        loadingView: Loading,
        selection: @escaping (String?) -> Void = { _ in }
    ) -> DetailViewController {

        let detailViewModel = DetailViewModel(
            detailLoader: MainQueueDispatchDecorator(
                decorate: detailLoader
            )
        )

        let detailController = DetailViewController.makeWith(
            viewModel: detailViewModel,
            loading: loadingView
        )

        detailViewModel.onDetailLoad = adaptDetailToCellController(
            forwardingTo: detailController,
            imageLoader: MainQueueDispatchDecorator(decorate: imageLoader),
            selection: selection
        )
        return detailController
    }

    private static func adaptDetailToCellController(
        forwardingTo controller: DetailViewController,
        imageLoader: ImageDataLoader,
        selection: @escaping (String?) -> Void
    ) -> ([DetailItem]) -> Void {

        return { [weak controller] detail in
            controller?.tableModel = detail.map { model in
                DetailCellController(
                    viewModel: DetailCellViewModel(
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

private extension DetailViewController {
    static func makeWith(viewModel: DetailViewModel, loading: Loading) -> DetailViewController {
        let bundle = Bundle(for: DetailViewController.self)
        let storyboard = UIStoryboard(name: "Detail", bundle: bundle)
        let detailController = storyboard.instantiateInitialViewController() as! DetailViewController
        detailController.viewModel = viewModel
        detailController.loader = loading
        return detailController
    }
}
