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
        preload()
        return cell
    }

    func preload() {
        viewModel.loadFlagImageData()
        viewModel.loadShieldImageData()
    }

    func cancelLoad() {
        releaseCellForReuse()
        viewModel.cancelImageDataLoad()
    }

    func selected() {
        selection()
    }

    public func display(_ viewModel: DetailCellViewModel<UIImage>) {
        cell?.nameLabel.text = viewModel.commonName
        cell?.flagLabel.text = viewModel.altFlag

        cell?.independentLabel.text = Localized.Detail.independentLabel
        cell?.independentImageView.image = viewModel.independent ? UIImage.makeCheckMark() : UIImage.makeXMark()
        cell?.independentImageView.tintColor = viewModel.independent ? UIColor.green : UIColor.red

        cell?.statusLabel.text = Localized.Detail.statusLabel
        cell?.statusImageView.image = viewModel.status ? UIImage.makeCheckMark() : UIImage.makeXMark()
        cell?.statusImageView.tintColor = viewModel.status ? UIColor.green : UIColor.red

        cell?.unMemberLabel.text = Localized.Detail.unmarkLabel
        cell?.unMemberImageView.image = viewModel.unMember ? UIImage.makeCheckMark() : UIImage.makeXMark()
        cell?.unMemberImageView.tintColor = viewModel.unMember ? UIColor.green : UIColor.red

    }

    private func bind(_ cell: DetailCell) -> DetailCell {
        self.cell = cell
        display(viewModel)

        viewModel.onFlagImageLoad = { [weak self] image in
            self?.cell?.flagImageView.setImageAnimated(image)
        }

        viewModel.onFlagImageLoadingStateChange = { [weak self] isLoading in
            self?.cell?.flagImageContainer.isShimmering = isLoading
        }

        viewModel.onFlagShouldRetryImageLoadStateChange = { [weak self] shouldRetry in
            self?.cell?.flagImageRetryButton.isHidden = !shouldRetry
        }

        viewModel.onShieldImageLoad = { [weak self] image in
            self?.cell?.shieldImageView.setImageAnimated(image)
        }

        viewModel.onShieldImageLoadingStateChange = { [weak self] isLoading in
            self?.cell?.shieldImageContainer.isShimmering = isLoading
        }

        viewModel.onShieldShouldRetryImageLoadStateChange = { [weak self] shouldRetry in
            self?.cell?.shieldImageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}

