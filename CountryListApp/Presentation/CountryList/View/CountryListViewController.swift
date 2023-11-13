//
//  CountryListViewController.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

final class CountryListViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    @IBOutlet private(set) public var errorView: ErrorView?
    var loader: LoaderProtocol?

    var viewModel: CountryListViewModel? {
        didSet { bind() }
    }
    
    var tableModel = [CountryCellController]() {
        didSet { tableView.reloadData() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction private func refresh() {
        viewModel?.loadCountry()
    }
    
    func bind() {
        title = viewModel?.title
        
        viewModel?.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.loader?.beginToLoading(in: self)
            } else {
                self?.loader?.endToLoading()
            }
        }
        
        viewModel?.onErrorStateChange = { [weak self] errorMessage in
            guard let errorMessage else {
                self?.errorView?.hideMessageAnimated()
                return
            }
            self?.errorView?.showAnimated(errorMessage)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).selected()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CountryCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
