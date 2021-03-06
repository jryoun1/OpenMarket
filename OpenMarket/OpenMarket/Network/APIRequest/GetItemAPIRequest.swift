//
//  GetItemAPIRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

struct GetItemAPIRequest: APIRequest {
    func makeRequest(from id: Int) throws -> URLRequest {
        guard var components = URLComponents(string: OpenMarketAPI.baseURL) else {
            throw OpenMarketError.failToMakeURL
        }
        components.path += "item/\(id)"
        
        return URLRequest(url: components.url!)
    }
    
    func parseResponse(data: Data) throws -> Item {
        return try JSONDecoder().decode(Item.self, from: data)
    }
}
