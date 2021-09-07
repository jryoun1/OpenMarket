//
//  UIImageView+GetImageFromServer.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/12.
//

import UIKit

extension UIImageView {
    func getImageFromServer(_ imageURL: String) {
        let getImageAPIReqeust = GetImageAPIRequest()
        let apiReqeustLoader = APIRequestLoader(apiReqeust: getImageAPIReqeust)
        
        let cacheKey = NSString(string: imageURL)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        apiReqeustLoader.loadAPIReqeust(requestData: imageURL, completion: { image, error in
            if let image = image {
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        })
    }
}
