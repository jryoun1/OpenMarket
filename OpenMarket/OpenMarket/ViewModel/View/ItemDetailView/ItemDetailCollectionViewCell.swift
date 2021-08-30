//
//  ItemDetailCollectionViewCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/30.
//

import UIKit

final class ItemDetailCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemDetailCollectionViewCell"
    private var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
