//
//  PatchItemAPIRequest.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/07.
//

import Foundation

struct PatchItemAPIRequest: APIRequest {
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
    
    private func createHttpBodyWithoutData(key: String, value: Any) throws -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        if let data = value as? String {
            body.append(data)
        }
        else if let data = value as? Int {
            body.append(String(data))
        }
        body.append("\r\n")
        
        return body
    }
}
