//
//  CountryListItem.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

struct CountryListItem: Decodable {

    let name: Name?
    let region: String?
    let subregion: String?
    let flags: flagsImage
    let capital: [String]?
    let timezones: [String]?
    let continents: [String]?

    struct Name: Decodable {
        let common: String?
        let official: String?
    }

    struct flagsImage: Decodable {
        let png: URL
        let svg: URL
    }

    struct Languages: Decodable {
        let eng: String?
    }

}

extension CountryListItem: Equatable {
    static func == (lhs: CountryListItem, rhs: CountryListItem) -> Bool {
        guard let lhsName = lhs.name, let rhsName = rhs.name else {
            return false
        }
        return lhsName.common == rhsName.common && lhsName.official == rhsName.official
    }
}
