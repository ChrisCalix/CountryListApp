//
//  Detail+Localized.swift
//  CountryListApp
//
//  Created by Christian Calixto on 13/11/23.
//

import Foundation

extension Localized {
    enum Detail {
        private static var table: String = "Detail"

        static var title: String {
            NSLocalizedString(
                "DETAIL_VIEW_TITLE",
                tableName: table,
                bundle: bundle,
                comment: "Title for the Detail View.")
        }

        static var loadError: String {
            NSLocalizedString(
                "DETAIL_CONNECTION_ERROR",
                tableName: table,
                bundle: bundle,
                comment: "Error message displayed when we can't load the Detail from the server.")
        }

        static var independentLabel: String {
            NSLocalizedString(
                "DETAIL_INDEPENDENT",
                tableName: table,
                bundle: bundle,
                comment: "Independent label description")
        }

        static var unmarkLabel: String {
            NSLocalizedString(
                "DETAIL_UNMARK",
                tableName: table,
                bundle: bundle,
                comment: "Unmark Label description")
        }

        static var statusLabel: String {
            NSLocalizedString(
                "DETAIL_STATUS",
                tableName: table,
                bundle: bundle,
                comment: "Status label description")
        }
    }
}
