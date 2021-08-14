//
//  ItemTableViewCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/09.
//

import UIKit

final class ItemTableViewCell: UITableViewCell {
    static let identifier = "ItemTableViewCell"
    @IBOutlet private var itemImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var stockLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var discountedPriceLabel: UILabel!
    @IBOutlet private var horizontalStackView: UIStackView!
}
