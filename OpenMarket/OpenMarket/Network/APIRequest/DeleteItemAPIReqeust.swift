//
//  DeleteItemAPIReqeust.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/06.
//

import Foundation

struct DeleteItemAPIReqeust: APIRequest {
    let id: Int
    func makeRequest(from data: ItemToDeletion) throws -> URLRequest {
        guard var components = URLComponents(string: OpenMarketAPI.baseURL) else {
            throw OpenMarketError.failToMakeURL
        }
        components.path += "item/\(id)"
        var request = URLRequest(url: components.url!)
        request.httpMethod = "\(HTTPMethod.DELETE)"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(data)
        
        return request
    }
    
    func parseResponse(data: Data) throws -> Item {
        return try JSONDecoder().decode(Item.self, from: data)
    }
}
