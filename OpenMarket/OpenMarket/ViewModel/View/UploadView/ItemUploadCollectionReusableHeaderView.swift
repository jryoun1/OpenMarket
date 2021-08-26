//
//  ItemUploadCollectionReusableHeaderView.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/25.
//

import UIKit

final class ItemUploadCollectionReusableHeaderView: UICollectionReusableView {
    static let identifier = "ItemUploadCollectionReusableHeaderView"
    @IBOutlet private var imageAddButton: UIButton!
    @IBOutlet private var imageCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
