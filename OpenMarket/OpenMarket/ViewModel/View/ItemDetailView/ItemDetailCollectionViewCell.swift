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
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureLayout() {
        self.contentView.addSubview(itemImageView)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            itemImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            itemImageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    func configure(image: UIImage) {
        self.itemImageView.image = image
    }
}
