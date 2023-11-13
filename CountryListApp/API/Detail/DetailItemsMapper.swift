//
//  DetailItemsMapper.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

final class DetailItemsMapper {
    private typealias Root = [DetailItem]

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [DetailItem] {
        guard response.isOk, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteDetailLoader.Error.invalidData
        }
        return root
    }
}
