//
//  PostItemAPIReqeust.swift
//  OpenMarket
//
//  Created by Yeon on 2021/08/06.
//

import Foundation

struct PostItemAPIReqeust: APIRequest {
    private let boundary: String = UUID().uuidString
    
    func makeRequest(from data: ItemToUpload) throws -> URLRequest {
        guard var components = URLComponents(string: OpenMarketAPI.baseURL) else {
            throw OpenMarketError.failToMakeURL
        }
        components.path += "item"
        var request = URLRequest(url: components.url!)
        request.httpMethod = "\(HTTPMethod.POST)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = makePostReqeustBody(from: data)
        
        return request
    }
    
    private func makePostReqeustBody(from data: ItemToUpload) -> Data {
        var body = Data()
        for (key, value) in data.parameters {
            if case Optional<Any>.none = value {
                continue
            }
            if let data = value as? [Data] {
                body.append(createHttpBodyWithData(key: key, value: data))
            }
            else {
                body.append(createHttpBodyWithoutData(key: key, value: value))
            }
        }
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private func createHttpBodyWithData(key: String, value: [Data]) -> Data {
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
    
    private func createHttpBodyWithoutData(key: String, value: Any) -> Data {
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
    
    func parseResponse(data: Data) throws -> Item {
        return try JSONDecoder().decode(Item.self, from: data)
    }
}
