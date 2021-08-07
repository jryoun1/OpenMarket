//
//  PatchItemAPIRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/07.
//

import Foundation

struct PatchItemAPIRequest: APIRequest {
    private let boundary: String = UUID().uuidString
}
