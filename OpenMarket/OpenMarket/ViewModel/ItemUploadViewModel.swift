//
//  ItemUploadViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/25.
//

import UIKit

final class ItemUploadViewModel {
    var selectedImageData: Observable<[Data]> = Observable([])
    var itemToUploadsInputErrorMessage: Observable<String> = Observable("")
    var isTitleTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isCurrencyTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPriceTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isDiscountedPriceTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isStockTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isDescriptionTextViewHighLighted: Observable<Bool> = Observable(false)
    var networkErrorMessage: Observable<String?> = Observable(nil)
}

//MARK:- TableView Configuration Property
extension ItemUploadViewModel {
    var numberOfSections: Int {
        return 1
    }
}
