//
//  CountryListViewController.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

final class CountryListViewController: UIViewController {

    @IBOutlet private(set) public var errorView: ErrorView?
   
    @IBOutlet weak var tableView: UITableView!

    var loader: Loading?

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
}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (cellController(forRowAt: indexPath).view(in: tableView))
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tableModel.indices.contains(indexPath.row) else {
            return
        }
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).selected()
    }

    private func cellController(forRowAt indexPath: IndexPath) -> CountryCellController {
        return tableModel[indexPath.row]
    }

    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

extension CountryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filter(by: searchText)
    }
}
