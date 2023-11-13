//
//  CountryCellController.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

final class CountryCellController {
    private let viewModel: CountryCellViewModel<UIImage>
    private var cell: CountryCell?
    private let selection: () -> Void
    
    init(viewModel: CountryCellViewModel<UIImage>, selection: @escaping () -> Void) {
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
    
    public func display(_ viewModel: CountryCellViewModel<UIImage>) {
        cell?.shortDetails.text = viewModel.details
        cell?.commonName.text = viewModel.commonName
        cell?.located.text = viewModel.located
        cell?.timezones.text = viewModel.timezone
        cell?.onRetry = viewModel.loadImageData
    }
    
    private func bind(_ cell: CountryCell) -> CountryCell {
        self.cell = cell
        display(viewModel)
        
        viewModel.onImageLoad = { [weak self] image in
            self?.cell?.countryImageView.setImageAnimated(image)
        }
        
        viewModel.onImageLoadingStateChange = { [weak self] isLoading in
            self?.cell?.countryImageContainer.isShimmering = isLoading
        }
        
        viewModel.onShouldRetryImageLoadStateChange = { [weak self] shouldRetry in
            self?.cell?.countryImageRetryButton.isHidden = !shouldRetry
        }
        
        return cell
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
