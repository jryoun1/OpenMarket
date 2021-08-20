//
//  ItemListCellViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/09.
//

import Foundation

struct ItemListCellViewModel {
    private let item: Item
    
    var title: String {
        return self.item.title
    }
    
    var price: String? {
        if let price = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: self.item.price)) {
            return "\(self.item.currency) \(price)"
        }
        return nil
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
    
    var stock: String? {
        if self.item.stock <= 0 {
            return "품절"
        }
        else {
            if let stock = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: self.item.stock)) {
                return "잔여수량: \(stock)"
            }
            return nil
        }
    }
    
    var imageURL: String? {
        if let imageURL = self.item.thumbnails.first {
            return imageURL
        }
        return nil
    }
    
    init(_ item: Item) {
        self.item = item
    }
}
