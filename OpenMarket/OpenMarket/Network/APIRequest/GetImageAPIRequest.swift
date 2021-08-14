//
//  GetImageAPIRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/12.
//

import UIKit

struct GetImageAPIRequest: APIRequest {
    func makeRequest(from imageURL: String) throws -> URLRequest {
        guard let url = URL(string: imageURL) else {
            throw OpenMarketError.failToMakeURL
        }
        
        return URLRequest(url: url)
    }
    
    func parseResponse(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            return UIImage(named: "AirPodMax2")!
        }
        return image
    }
}
