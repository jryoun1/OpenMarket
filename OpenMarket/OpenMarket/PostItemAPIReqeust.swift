//
//  PostItemAPIReqeust.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/06.
//

import Foundation

struct PostItemAPIReqeust: APIRequest {
    private let boundary: String = UUID().uuidString
    
    private func createHttpBodyWithData(key: String, value: [Data]) throws -> Data {
        var body = Data()
        for image in value {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)[]\"; filename=\"\(Date()).jpeg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(image)
            body.append("\r\n")
        }
        return body
    }
}
