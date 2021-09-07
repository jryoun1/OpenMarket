//
//  ItemListViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/09.
//

import UIKit

final class ItemListViewModel {
    private var apiRequestLoader: APIRequestLoader<GetItemListAPIRequest>!
    var currentPage: Int = 1
    var isPaging: Bool = false
    var hasNextPage: Bool = false
    var isItemChanged: Bool = false
    var itemList: Observable<[Item]> = Observable([])
    
    func fetchData(page: Int) {
        let getItemListAPIRequest = GetItemListAPIRequest()
        apiRequestLoader = APIRequestLoader(apiReqeust: getItemListAPIRequest)
        
        apiRequestLoader.loadAPIReqeust(requestData: page) { [weak self] itemList, error in
            guard let itemList = itemList, itemList.items.count > 0 else {
                self?.hasNextPage = false
                return
            }
            
            self?.hasNextPage = true
            _ = itemList.items.compactMap({ item in
                self?.itemList.value?.append(item)
            })
        }
    }
}

//MARK:- TableView Configuration Property
extension ItemListViewModel {
    var numberOfSections: Int {
        return 1
    }
}
