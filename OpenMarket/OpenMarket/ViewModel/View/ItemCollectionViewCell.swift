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
    
    func configureCell(with viewModel: ItemTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        if let imageURL = viewModel.imageURL {
            itemImageView.getImageFromServer(imageURL)
        }
        else {
            itemImageView.image = UIImage(named: "DefaultImage")
        }
        
        if let stockString = viewModel.stock {
            if stockString == "품절" {
                stockLabel.textColor = .systemOrange
            }
            else {
                stockLabel.textColor = .systemGray
            }
            stockLabel.text = stockString
        }
        else {
            stockLabel.text = "오류가 발생했습니다."
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
            priceLabel.text = "오류가 발생하였습니다."
        }
    }
    
    private func changeToStrikethroughStyle(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}
