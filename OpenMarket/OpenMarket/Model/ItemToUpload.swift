//
//  ItemToUpload.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

struct ItemToUpload: Encodable {
    var title: String? = ""
    var descriptions: String? = ""
    var price: Int? = 0
    var currency: String? = ""
    var stock: Int? = 0
    var discountedPrice: Int? = nil
    var images: [Data]? = []
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images
        case discountedPrice = "discounted_price"
    }
    
    var parameters: [String: Any] {
        [
            "title": title,
            "descriptions": descriptions,
            "price": price,
            "currency": currency,
            "stock": stock,
            "discounted_price": discountedPrice,
            "images": images,
            "password": password
        ]
    }
}
