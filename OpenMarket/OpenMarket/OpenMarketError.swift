//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

enum OpenMarketError: Error {
    case failToNetworkCommunication
    case failToMakeURL
    case failDecodeData
    case failGetData
    case failPostData
    case failPatchData
    case failDeleteData
    case unknown
}
