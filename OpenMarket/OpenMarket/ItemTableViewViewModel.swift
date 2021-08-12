//
//  ItemTableViewViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/09.
//

import UIKit

struct ItemTableViewViewModel {
    var itemList: Observable<[ItemTableViewCellViewModel]> = Observable([])
}
