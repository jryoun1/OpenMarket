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
            throw // error
        }
        components.path += "item/\(id)"
        
        return URLRequest(url: components.url!)
    }
}
