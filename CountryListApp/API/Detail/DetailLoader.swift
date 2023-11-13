//
//  DetailLoader.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

protocol DetailLoader {
    typealias Result = Swift.Result<[DetailItem], Error>

    func load(completion: @escaping (Result) -> Void)
}
