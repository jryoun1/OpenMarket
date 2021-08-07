//
//  APIRequestLoader.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

protocol APIRequest {
    associatedtype RequestDataType
    associatedtype ResponseDataType
    
    func makeRequest(from data: RequestDataType) throws -> URLRequest
    func parseResponse(data: Data) throws -> ResponseDataType
}
