//
//  CountryListItemsMapper.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

final class CountryItemsMapper {
    private typealias Root = [CountryListItem]
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [CountryListItem] {
        guard response.isOk, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteCountryLoader.Error.invalidData
        }
        return root
    }
}
