//
//  ItemUploadViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/25.
//

import UIKit

final class ItemUploadViewModel {
    var selectedImages: Observable<[UIImage]> = Observable([])
}

//MARK:- TableView Configuration Property
extension ItemUploadViewModel {
    var numberOfSections: Int {
        return 1
    }
}
