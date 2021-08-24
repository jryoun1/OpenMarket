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
    
    func configureCell(with viewModel: ItemListCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        if let imageURL = viewModel.imageURL {
            itemImageView.getImageFromServer(imageURL)
        }
        else {
            itemImageView.image = UIImage(named: "DefaultImage")
        }
        
        if let stockString = viewModel.stock {
            if stockString == ItemListViewString.soldOut {
                stockLabel.textColor = .systemOrange
            }
            else {
                stockLabel.textColor = .systemGray
            }
            stockLabel.text = stockString
        }
        else {
            stockLabel.text = ItemListViewString.errorMessage
        }
        
        if let priceString = viewModel.price {
            if let discountedPriceString = viewModel.discountedPrice {
                discountedPriceLabel.isHidden = false
                priceLabel.textColor = .systemRed
                priceLabel.attributedText = changeToStrikethroughStyle(string: priceString)
                
                discountedPriceLabel.textColor = .systemGray
                discountedPriceLabel.text = discountedPriceString
            }
            else {
                priceLabel.textColor = .systemGray
                priceLabel.attributedText = NSAttributedString(string: priceString)
            }
        }
        else {
            priceLabel.text = ItemListViewString.errorMessage
        }
    }
    
    private func changeToStrikethroughStyle(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        titleLabel.text = nil
        stockLabel.text = nil
        priceLabel.attributedText = nil
        discountedPriceLabel.text = nil
        discountedPriceLabel.isHidden = true
    }
}
