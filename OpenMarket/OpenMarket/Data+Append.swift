//
//  Data+Append.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/07.
//

import Foundation

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
