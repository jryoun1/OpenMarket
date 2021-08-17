//
//  ItemList.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/03.
//

struct ItemList: Decodable {
    let page: Int
    let items: [Item]
}
