//
//  DetailCellController.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import UIKit

final class DetailCellController {
    private let viewModel: DetailCellViewModel<UIImage>
    private var cell: DetailCell?
    private let selection: () -> Void

    init(viewModel: DetailCellViewModel<UIImage>, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.selection = selection
    }

    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = bind(tableView.dequeueReusableCell())
        viewModel.loadImageData()
        return cell
    }

    func preload() {
        viewModel.loadImageData()
    }

    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }

    func selected() {
        selection()
    }

    public func display(_ viewModel: DetailCellViewModel<UIImage>) {
//        cell?.shortDetails.text = viewModel.details
//        cell?.commonName.text = viewModel.commonName
//        cell?.located.text = viewModel.located
//        cell?.timezones.text = viewModel.timezone
        cell?.onRetry = viewModel.loadImageData
    }

    private func bind(_ cell: DetailCell) -> DetailCell {
        self.cell = cell
        display(viewModel)

        viewModel.onImageLoad = { [weak self] image in
            self?.cell?.detailImageView.setImageAnimated(image)
        }

        viewModel.onImageLoadingStateChange = { [weak self] isLoading in
            self?.cell?.detailImageContainer.isShimmering = isLoading
        }

        viewModel.onShouldRetryImageLoadStateChange = { [weak self] shouldRetry in
            self?.cell?.detailImageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

