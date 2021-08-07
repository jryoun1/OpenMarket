//
//  PostItemAPIReqeust.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/06.
//

import Foundation

struct PostItemAPIReqeust: APIRequest {
    private let boundary: String = UUID().uuidString
}
