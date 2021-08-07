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

final class APIRequestLoader<T: APIRequest> {
    let apiRequest: T
    let urlSession: URLSession
    
    init(apiReqeust: T, urlSession: URLSession = .shared) {
        self.apiRequest = apiReqeust
        self.urlSession = urlSession
    }
    
    func loadAPIReqeust(requestData: T.RequestDataType,
                        completion: @escaping (T.ResponseDataType?, Error?) -> Void) {
        do {
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let _ = error {
                    return completion(nil, error)
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    return completion(nil, error)
                }
                
                guard let data = data else {
                    return completion(nil, error)
                }
                
                do {
                    let parseResponse = try self.apiRequest.parseResponse(data: data)
                    completion(parseResponse, nil)
                } catch {
                    completion(nil, error)
                }
            }.resume()
        } catch {
            return completion(nil, error)
        }
    }
}
