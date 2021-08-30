//
//  ItemUploadCollectionViewCell.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/26.
//

import UIKit

protocol DeleteImage: AnyObject {
    func delete(index: Int)
}

final class ItemUploadCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemUploadCollectionViewCell"
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var deleteButton: UIButton!
    weak var deleteImageDelegate: DeleteImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func didDeleteButtonTouchedUp(_ sender: UIButton) {
        deleteImageDelegate?.delete(index: self.tag)
    }
    
    func configure(data: Data) {
        itemImageView.image = UIImage(data: data)
    }
    
    override func prepareForReuse() {
        itemImageView.image = nil
    }
}
