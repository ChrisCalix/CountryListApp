//
//  DetailEndpoint.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

enum DetailEndpoint {
    case getDetailBy(name: String)

    func url(baseURL: URL) -> URL {
        switch self {
        case let .getDetailBy(name):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v3.1/name/\(name)"
            return components.url!
        }
    }
}
