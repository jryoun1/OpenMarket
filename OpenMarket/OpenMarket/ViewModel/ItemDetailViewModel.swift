//
//  ItemDetailViewModel.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/29.
//

import UIKit

final class ItemDetailViewModel {
    private let id: Int
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
}
