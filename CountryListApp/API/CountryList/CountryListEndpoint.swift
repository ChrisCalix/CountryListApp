//
//  CountryListEndpoint.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

enum CountryListEndpoint {
    case getAll
    
    func url(baseURL: URL) -> URL {
        switch self {
        case .getAll:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v3.1/all"
            return components.url!
        }
    }
}
