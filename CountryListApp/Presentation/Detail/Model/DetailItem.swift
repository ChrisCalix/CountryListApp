//
//  DetailItem.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

struct DetailItem: Decodable {
    let name: Name?
    let independent: Bool?
    let status: String?
    let unMember: Bool?
    let capital: [String]?
    let region: String?
    let subregion: String?
    let maps: Maps?
    let timezones: [String]?
    let continents: [String]?
    let flags: Flags?
    let startOfWeek: String?
    let coatOfArms: CoatOfArms?

    struct Name: Decodable {
        let common: String?
        let official: String?
    }

    struct Maps: Decodable {
        let googleMaps: String?
        let openStreetMaps: String?
    }

    struct Flags: Decodable {
        let png: URL?
        let svg: URL?
        let alt: String?
    }

    struct CoatOfArms: Decodable {
        let png: URL?
        let svg: URL?
    }
}

extension DetailItem: Equatable {
    static func == (lhs: DetailItem, rhs: DetailItem) -> Bool {
        guard let lhsName = lhs.name, let rhsName = rhs.name else {
            return false
        }
        return lhsName.common == rhsName.common && lhsName.official == rhsName.official
    }
}
