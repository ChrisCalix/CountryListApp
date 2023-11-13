//
//  CountryListItem.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

public struct CountryListItem: Decodable {
    
    let name: Name?
    let region: String?
    let subregion: String?
    let flags: flagsImage
    let capital: [String]?
    let timezones: [String]?
    let continents: [String]?
    
    public struct Name: Decodable {
        let common: String?
        let official: String?
    }
    
    public struct flagsImage: Decodable {
        let png: URL
        let svg: URL
    }
    
    public struct Languages: Decodable {
        let eng: String?
    }
}
