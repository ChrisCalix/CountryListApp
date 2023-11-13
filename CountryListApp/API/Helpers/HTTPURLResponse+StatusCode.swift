//
//  HTTPURLResponse+StatusCode.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int {
        return 200
    }
    
    var isOk: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
