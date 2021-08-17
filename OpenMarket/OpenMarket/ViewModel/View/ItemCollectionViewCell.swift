//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/18.
//

import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"
    @IBOutlet private var itemImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var stockLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var discountedPriceLabel: UILabel!
    @IBOutlet private var verticalStackView: UIStackView!
    
}
