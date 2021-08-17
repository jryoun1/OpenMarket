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
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureFooterView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureFooterView() {
        contentView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30),
            loadingIndicator.heightAnchor.constraint(equalTo: loadingIndicator.widthAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
    }
}
