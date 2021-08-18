//
//  ItemCollectionReusableFooterView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/18.
//

import UIKit

final class ItemCollectionReusableFooterView: UICollectionReusableView {
    static let identifier = "ItemCollectionReusableFooterView"
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemGray
        indicator.style = .medium
        return indicator
    }()
}
