//
//  ItemUploadViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/25.
//

import UIKit

final class ItemUploadViewModel {
    var selectedImageData: Observable<[Data]> = Observable([])
    var titleTextFiledtext: Observable<String> = Observable("")
    var currencyTextFiledtext: Observable<String> = Observable("")
    var priceTextFiledtext: Observable<String> = Observable("")
    var discountedPriceTextFiledtext: Observable<String> = Observable("")
    var stockTextFieldtext: Observable<String> = Observable("")
    var passwordTextFieldtext: Observable<String> = Observable("")
    var descriptionTextViewtext: Observable<String> = Observable("")
    
    var itemToUploadsInputErrorMessage: Observable<String> = Observable("")
    var isTitleTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isCurrencyTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPriceTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isDiscountedPriceTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isStockTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isPasswordTextFieldHighLighted: Observable<Bool> = Observable(false)
    var isDescriptionTextViewHighLighted: Observable<Bool> = Observable(false)
    var networkingResult: Observable<OpenMarketError> = Observable(nil)
    
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
    private var imageData = [Data]()
    
    private var itemToUpload = ItemToUpload() {
        didSet {
            title = itemToUpload.title!
            currency = itemToUpload.currency!
            price = itemToUpload.price ?? nil
            discountedPrice = itemToUpload.discountedPrice ?? nil
            stock = itemToUpload.stock ?? nil
            password = itemToUpload.password
            description = itemToUpload.descriptions!
            imageData = itemToUpload.images ?? []
        }
    }
    
    private var id: Int?
    private var originTitle = ""
    private var originCurrency = ""
    private var originPrice: Int?
    private var originDiscountedPrice: Int?
    private var originStock: Int?
    private var originPassword = ""
    private var originDescription = ""
    private var originImageData = [Data]()
    
    init(itemToUpload: ItemToUpload? = nil, id: Int? = nil) {
        self.id = id
        originTitle = itemToUpload?.title ?? ""
        originCurrency = itemToUpload?.currency ?? ""
        originPrice = itemToUpload?.price
        originDiscountedPrice = itemToUpload?.discountedPrice
        originStock = itemToUpload?.stock
        originPassword = itemToUpload?.password ?? ""
        originDescription = itemToUpload?.descriptions ?? ""
        originImageData = itemToUpload?.images ?? []
        
        titleTextFiledtext.value = originTitle
        currencyTextFiledtext.value = originCurrency
        priceTextFiledtext.value = originPrice?.description
        discountedPriceTextFiledtext.value = originDiscountedPrice?.description
        stockTextFieldtext.value = originStock?.description
        passwordTextFieldtext.value = originPassword
        descriptionTextViewtext.value = originDescription
        selectedImageData.value = originImageData
    }
    
    func updateItemToUpload(title: String, currency: String, price: Int?, discountedPrice: Int?, stock: Int?, password: String, description: String, imageData: [Data]) {
        itemToUpload.title = title
        itemToUpload.currency = currency
        itemToUpload.price = price
        itemToUpload.discountedPrice = discountedPrice
        itemToUpload.stock = stock
        itemToUpload.password = password
        itemToUpload.descriptions = description
        itemToUpload.images = imageData
    }
    
    func post() {
        let postItemAPIRequest = PostItemAPIReqeust()
        let apiRequestLoader = APIRequestLoader(apiReqeust: postItemAPIRequest)
        
        guard let price = self.price,
              let stock = self.stock else {
            return
        }
        
        let itemToUploads = ItemToUpload(title: self.title,
                                         descriptions: self.description,
                                         price: price,
                                         currency: self.currency,
                                         stock: stock,
                                         discountedPrice: self.discountedPrice,
                                         images: self.imageData,
                                         password: self.password)
        
        
        apiRequestLoader.loadAPIReqeust(requestData: itemToUploads) { [weak self] item, error in
            if let error = error {
                self?.networkingResult.value = error
            }
            
            self?.networkingResult.value = .successPOST
        }
    }
    
    func patch() {
        guard let id = id else {
            return
        }
        
        let patchItemAPIRequest = PatchItemAPIRequest(id: id)
        let apiRequestLoader = APIRequestLoader(apiReqeust: patchItemAPIRequest)
        
        var patchImageData: [Data] = []
        var patchTitle: String? = nil
        var patchCurrency: String? = nil
        var patchPrice: Int? = nil
        var patchDiscountedPrice: Int? = nil
        var patchStock: Int? = nil
        var patchDescription: String? = nil
        
        if title != originTitle {
            patchTitle = title
        }
        if currency != originCurrency {
            patchCurrency = currency
        }
        if price != originPrice {
            patchPrice = price
        }
        if discountedPrice != originDiscountedPrice {
            patchDiscountedPrice = discountedPrice
        }
        if stock != originStock {
            patchStock = stock
        }
        if description != originDescription {
            patchDescription = description
        }
        if imageData != originImageData {
            patchImageData = imageData
        }
        
        apiRequestLoader.loadAPIReqeust(requestData: ItemToUpload(title: patchTitle,
                                                                  descriptions: patchDescription,
                                                                  price: patchPrice,
                                                                  currency: patchCurrency,
                                                                  stock: patchStock,
                                                                  discountedPrice: patchDiscountedPrice,
                                                                  images: patchImageData,
                                                                  password: password)) { [weak self] item, error in
            if let error = error {
                self?.networkingResult.value = error
            }
            
            self?.networkingResult.value = .successPATCH
        }
    }
    
    func checkItemToUploadInput() -> ItemToUploadInputStatus {
        if let imageCount = selectedImageData.value?.count {
            if  imageCount < 1 || imageCount > 5 {
                itemToUploadsInputErrorMessage.value = ItemUploadViewString.imageCountLimitMessage
                return .Incorrect
            }
        }
        if title.isEmpty {
            itemToUploadsInputErrorMessage.value = ItemUploadViewString.titleEmptyMessage
            isTitleTextFieldHighLighted.value = true
            return .Incorrect
        }
        if currency.isEmpty {
            itemToUploadsInputErrorMessage.value = ItemUploadViewString.currencyEmptyMessage
            isCurrencyTextFieldHighLighted.value = true
            return .Incorrect
        }
        if price == nil {
            itemToUploadsInputErrorMessage.value = ItemUploadViewString.priceEmptyMessage
            isPriceTextFieldHighLighted.value = true
            return .Incorrect
        }
        if stock == nil {
            itemToUploadsInputErrorMessage.value = ItemUploadViewString.stockEmptyMessage
            isStockTextFieldHighLighted.value = true
            return .Incorrect
        }
        if password.isEmpty {
            itemToUploadsInputErrorMessage.value = ItemUploadViewString.passwordEmptyMessage
            isPasswordTextFieldHighLighted.value = true
            return .Incorrect
        }
        if description == ItemUploadViewString.descriptionPlaceholder || description.isEmpty {
            itemToUploadsInputErrorMessage.value = ItemUploadViewString.descriptionEmptyMessage
            isDescriptionTextViewHighLighted.value = true
            return .Incorrect
        }
        return .Correct
    }
}

//MARK:- TableView Configuration Property
extension ItemUploadViewModel {
    var numberOfSections: Int {
        return 1
    }
}
