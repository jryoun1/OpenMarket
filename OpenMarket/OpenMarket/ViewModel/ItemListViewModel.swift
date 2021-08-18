//
//  ItemListViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/09.
//

import UIKit

struct ItemListViewModel {
    var itemList: Observable<[ItemTableViewCellViewModel]> = Observable([])
}

//MARK:- TableView Configuration Property
extension ItemListViewModel {
    var numberOfSections: Int {
        return 1
    }
}
