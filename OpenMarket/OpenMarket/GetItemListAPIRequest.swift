//
//  GetItemListAPIRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//
import Foundation

struct GetItemListAPIRequest: APIRequest {
    func makeRequest(from page: Int) throws -> URLRequest {
        guard var components = URLComponents(string: OpenMarketAPI.baseURL) else {
            throw // error
        }
        components.path += "items/\(page)"
        
        return URLRequest(url: components.url!)
    }
    
    func parseResponse(data: Data) throws -> ItemList {
        return try JSONDecoder().decode(ItemList.self, from: data)
    }
}
