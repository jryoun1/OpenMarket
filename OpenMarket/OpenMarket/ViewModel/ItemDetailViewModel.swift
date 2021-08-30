//
//  ItemDetailViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/29.
//

import UIKit

final class ItemDetailViewModel {
    private let id: Int
    private var item: Item?
    var titleLabeltext: Observable<String> = Observable("")
    var priceLabeltext: Observable<String> = Observable("")
    var discountedPriceLabeltext: Observable<String> = Observable("")
    var stockTextLabeltext: Observable<String> = Observable("")
    var descriptionLabeltext: Observable<String> = Observable("")
    var errorText: Observable<String> = Observable("")
    var images: Observable<[UIImage]> = Observable([])
    
    init(id: Int) {
        self.id = id
    }
    
    func fetchItem() {
        let getItemAPIRequest = GetItemAPIRequest()
        let apiRequestLoader = APIRequestLoader(apiReqeust: getItemAPIRequest)
        
        apiRequestLoader.loadAPIReqeust(requestData: id) { [weak self] item, error in
            if let error = error {
                self?.errorText.value = error.localizedDescription
            }
            
            guard let item = item else {
                return
            }
            self?.item = item
            self?.titleLabeltext.value = item.title
            
            let priceWithComma = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: item.price))!
            self?.priceLabeltext.value = "\(item.currency) \(priceWithComma)"
            
            if let discountedPrice = item.discountedPrice {
                let discountedPriceWithComma = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: discountedPrice))!
                self?.discountedPriceLabeltext.value = "\(item.currency) \(discountedPriceWithComma)"
            }
            
            if item.stock <= 0 {
                self?.stockTextLabeltext.value = ItemListViewString.soldOut
            }
            else {
                let stock = CustomNumberFormatter.commaFormatter.string(from: NSNumber(value: item.stock))!
                self?.stockTextLabeltext.value = "\(ItemListViewString.remainingQuantity) \(stock)"
            }
            
            self?.descriptionLabeltext.value = item.descriptions
            
            if let imageURLs = item.imageURLs {
                for imageURL in imageURLs {
                    self?.downloadImage(url: imageURL)
                }
            }
        }
    }
    
    private func downloadImage(url: String) {
        let imageAPIRequest = GetImageAPIRequest()
        let apiRequestLoader = APIRequestLoader(apiReqeust: imageAPIRequest)
        
        apiRequestLoader.loadAPIReqeust(requestData: url) { [weak self] image, error in
            if let error = error {
                self?.errorText.value = error.localizedDescription
            }
            
            guard let image = image else {
                return
            }
            
            self?.images.value?.append(image)
        }
    }
    
    func prepareItemToUpload(password: String) -> (id: Int, item: ItemToUpload) {
        var imagedata = [Data]()
        if let images = self.images.value {
            for itemImage in images {
                if let image = UIImageToDataType(image: itemImage) {
                    imagedata.append(image)
                }
            }
        }
        
        let item = ItemToUpload(title: self.item?.title,
                                descriptions: self.item?.descriptions,
                                price: self.item?.price,
                                currency: self.item?.currency,
                                stock: self.item?.stock,
                                discountedPrice: self.item?.discountedPrice,
                                images: imagedata,
                                password: password)
        return (id, item)
    }
    
    private func UIImageToDataType(image: UIImage) -> Data? {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return data
    }
}

extension ItemDetailViewModel {
    var numberOfSections: Int {
        return 1
    }
}
