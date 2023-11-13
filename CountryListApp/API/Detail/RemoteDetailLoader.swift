//
//  RemoteDetailLoader.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

final class RemoteDetailLoader: DetailLoader {

    private let url: URL
    private let client: HTTPClient

    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    typealias Result = DetailLoader.Result

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success((data, response)):
                completion(RemoteDetailLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }

    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try DetailItemsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}
