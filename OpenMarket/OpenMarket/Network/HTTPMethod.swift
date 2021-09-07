//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/07.
//

enum HTTPMethod: String, CustomStringConvertible {
    case GET
    case POST = "등록"
    case PATCH = "수정"
    case DELETE
    
    var description: String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        case .PATCH:
            return "PATCH"
        case .DELETE:
            return "DELETE"
        }
    }
}
