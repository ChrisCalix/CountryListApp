//
//  CountryListLoader.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

protocol CountryListLoader {
    typealias Result = Swift.Result<[CountryListItem], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
