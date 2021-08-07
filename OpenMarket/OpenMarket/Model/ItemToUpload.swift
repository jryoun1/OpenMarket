//
//  ItemToUpload.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

struct ItemToUpload: Encodable {
    let title: String?
    let descriptions: String?
    let price: Int?
    let currency: String?
    let stock: Int?
    let discountedPrice: Int?
    let images: [Data]?
    let password: String
    
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
