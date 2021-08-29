//
//  ItemDetailViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/29.
//

import UIKit

final class ItemDetailViewModel {
    private let id: Int
    var titleLabeltext: Observable<String> = Observable("")
    var priceLabeltext: Observable<String> = Observable("")
    var discountedPriceLabeltext: Observable<String> = Observable("")
    var stockTextLabeltext: Observable<String> = Observable("")
    var descriptionLabeltext: Observable<String> = Observable("")
    var errorText: Observable<String> = Observable("")
    var images: Observable<[UIImage]> = Observable([])
    
    init(id: Int) {
        self.id = id
    }
}
