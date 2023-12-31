//
//  UITableView+DequeueReusableCell.swift
//  CountryListApp
//
//  Created by Sonic on 13/11/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
