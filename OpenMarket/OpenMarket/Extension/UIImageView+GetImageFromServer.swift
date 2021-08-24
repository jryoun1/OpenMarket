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
        
        apiReqeustLoader.loadAPIReqeust(requestData: imageURL, completion: { image, error in
            if let image = image {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        })
    }
}
