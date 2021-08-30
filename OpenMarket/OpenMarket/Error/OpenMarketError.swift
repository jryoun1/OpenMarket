//
//  OpenMarketError.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/04.
//

import Foundation

enum OpenMarketError: Error {
    case failToNetworkCommunication
    case badRequest
    case notFound
    case failToMakeURLRequest
    case failToMakeURL
    case failDecodeData
    case failUnwrappingData
    case successPOST
    case successPATCH
    case successDELETE
    case unknown
}

extension OpenMarketError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failToNetworkCommunication:
            return "네트워크 통신을 실패하였습니다."
        case .badRequest:
            return "요청이 잘못되었습니다."
        case .notFound:
            return "정보를 찾을 수 없습니다."
        case .failToMakeURLRequest:
            return "옳바른 URLRequest를 생성하는데 실패하였습니다."
        case .failToMakeURL:
            return "옳바른 URL을 생성하는데 실패하였습니다."
        case .failDecodeData:
            return "데이터 디코딩에 실패하였습니다."
        case .failUnwrappingData:
            return "데이터를 추출하는데 실패하였습니다."
        case .unknown:
            return "알 수 없는 에러가 발생하였습니다."
        case .successPOST:
            return "등록을 완료하였습니다"
        case .successDELETE:
            return "삭제를 완료하였습니다"
        case .successPATCH:
            return "수정을 완료하였습니다"
        }
    }
}
