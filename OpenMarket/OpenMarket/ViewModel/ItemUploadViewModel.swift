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
    
    enum ItemToUploadInputStatus {
        case Correct
        case Incorrect
    }
    
    private var title = ""
    private var currency = ""
    private var price: Int?
    private var discountedPrice: Int?
    private var stock: Int?
    private var password = ""
    private var description = ""
    
    private var itemToUpload = ItemToUpload() {
        didSet {
            title = itemToUpload.title!
            currency = itemToUpload.currency!
            price = itemToUpload.price ?? nil
            discountedPrice = itemToUpload.discountedPrice ?? nil
            stock = itemToUpload.stock ?? nil
            password = itemToUpload.password
            description = itemToUpload.descriptions!
        }
    }
}

//MARK:- TableView Configuration Property
extension ItemUploadViewModel {
    var numberOfSections: Int {
        return 1
    }
}
