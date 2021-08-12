//
//  ItemTableViewCellViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/09.
//

import Foundation

struct ItemTableViewCellViewModel {
    private let item: Item
    
    var price: String {
        if let price = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: self.item.price)) {
            return "\(self.item.currency) \(price)"
        }
        return "가격을 표시하는데 문제가 발생했습니다."
    }
    
    var discountedPrice: String? {
        if let discountedPrice = self.item.discountedPrice,
           let discountedPriceWithComma = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: discountedPrice)) {
            return "\(self.item.currency) \(discountedPriceWithComma)"
        }
        else {
            return nil
        }
    }
}
