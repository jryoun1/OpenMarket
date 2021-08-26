//
//  ItemUploadCollectionViewCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/26.
//

import UIKit

final class ItemUploadCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemUploadCollectionViewCell"
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(image: UIImage) {
        itemImageView.image = image
    }
    
    override func prepareForReuse() {
        itemImageView.image = nil
    }
}
