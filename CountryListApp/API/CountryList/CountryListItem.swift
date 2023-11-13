//
//  CountryListItem.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

struct CountryListItem: Decodable, Equatable {
    
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
    
    static func == (lhs: CountryListItem, rhs: CountryListItem) -> Bool {
        guard let lhsCommon = lhs.name?.common, let rhsCommon = rhs.name?.common else {
            return false
        }
        return lhsCommon == rhsCommon
    }
}
