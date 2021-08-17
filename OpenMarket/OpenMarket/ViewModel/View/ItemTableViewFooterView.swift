//
//  ItemTableViewFooterView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/17.
//

import UIKit

final class ItemTableViewFooterView: UITableViewHeaderFooterView {
    static let identifier = "ItemTableViewFooterView"
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemGray
        indicator.style = .medium
        return indicator
    }()
}
