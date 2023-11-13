//
//  Localized.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import Foundation

final class Localized {
    static var bundle: Bundle {
        Bundle(for: Localized.self)
    }
}

extension Localized {
    enum CountryList {
        private static var table: String = "CountryList"
        
        static var title: String {
            NSLocalizedString(
                "COUNTRY_LIST_VIEW_TITLE",
                tableName: table,
                bundle: bundle,
                comment: "Title for the Country List View.")
        }
        
        static var loadError: String {
            NSLocalizedString(
                "COUNTRY_LIST_CONNECTION_ERROR",
                tableName: table,
                bundle: bundle,
                comment: "Error message displayed when we can't load the image feed from the server.")
        }
    }
}
