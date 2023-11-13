//
//  CountryList+Localized.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

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
                comment: "Error message displayed when we can't load the Country item from the server.")
        }
    }
}
